use v6;

use PDF::DOM::Composition::Content;
use PDF::DOM::Type::XObject;
use PDF::DOM::Util::Font;
use PDF::DOM::Type::Font;

#| this role is applied to PDF::DOM::Type::Pages and PDF::DOM::Type::XObject::Form
role PDF::DOM::Composition {

    has PDF::DOM::Composition::Content $.pre-gfx = PDF::DOM::Composition::Content.new( :parent(self) ); #| prepended graphics
    has PDF::DOM::Composition::Content $.gfx     = PDF::DOM::Composition::Content.new( :parent(self) ); #| appended graphics

    method Resources is rw { self<Resources> }
    method MediaBox is rw { self<MediaBox> }
    method Contents is rw { self<Contents> }

    method core-font( *@arg, *%opt ) {
        my $core-font = PDF::DOM::Util::Font::core-font( |@arg, |%opt );
        my Pair $entry = self!"find-resource"(sub ($_){.isa(PDF::DOM::Type::Font) && .font-obj === $core-font}, :type<Font>)
            // do {
                my %params = $core-font.to-dom('Font');
                my $new-obj = PDF::Object.compose( |%params );
                my Pair $new-entry = self.register-resource( $new-obj );
                $new-entry.value.key = $new-entry.key;
                $new-entry;
        };
        $entry.value;
    }

    method !find-resource( &match, Str :$type! ) {
        my $resources = self.find-prop('Resources')
            // {};

        my $found;

        if $resources = $resources{$type} {

            for $resources.keys {
                my $resource = $resources{$_};
                if &match($resource) {
                    $found = $_ => $resource;
                    last;
                }
            }
        }

        $found;
    }

    multi method register-resource( PDF::DOM::Type::XObject $object) {
        my $base-name = do given $object.Subtype {
            when 'Form'  {'Fm'}
            when 'Image' {'Im'}
            default {die "Unhandled XObject.Subtype: $_"}
        }
        self!"add-resource"( $object, :$base-name, );
    }

    multi method register-resource( PDF::DOM::Type::Font $object) {
        self!"add-resource"( $object, :base-name<F>, );
    }

    #| ensure that the object is registered as a page resource. Return a unique
    #| name for it.
    method !add-resource(PDF::Object $object,
                         Str :$base-name = <Obj>,
                         :$type = $object.Type
        --> Pair ) {
        my $id = $object.id;
        my $resources = self.find-prop('Resources')
            // do {
                self.Resources = {};
                self.Resources
        };

        $resources{$type} //= {};

        my $name = (1..*).map({$base-name ~ $_}).first({ $resources{$type}{$_}:!exists });
        $resources{$type}{$name} = $object;

        $name => $object;
    }

    method cb-finish {

        if $!pre-gfx.ops || $!gfx.ops {

            my $new-content;

            # wrap new content in save ... restore - for safety's sake
            for $!pre-gfx, $!gfx {
                if .defined && .ops {
                    $new-content = True;
                    .save(:prepend);
                    .restore;
                }
            }

            # also wrap any existing content in save ... restore
            if $new-content {
                my $content = self.decoded;
                if $content.defined && $content.chars
                    && ($content !~~ m:s/^ 'q' /  || $content !~~ m:s/ 'Q' ^/) {
                        $!pre-gfx.save;
                        $!gfx.restore(:prepend);
                }

                my $prepend = $!pre-gfx.ops
                    ?? $!pre-gfx.content ~ "\n"
                    !! '';

                my $append = $!gfx.ops
                    ?? "\n" ~ $!gfx.content
                    !! '';

                self.edit-stream(:$prepend, :$append)
                    if $prepend.chars || $append.chars;
            }
        }
    }

}
