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
    method Contents is rw { self<Contents> }

    role ResourceEntry {
        has Str $.key is rw;
    }

    method core-font( *@arg, *%opt ) {
        my $core-font = PDF::DOM::Util::Font::core-font( |@arg, |%opt );
        my Pair $lookup = self!"find-resource"(sub ($_){.isa(PDF::DOM::Type::Font) && .font-obj === $core-font}, :type<Font>)
            // do {
                my %params = $core-font.to-dom('Font');
                my $new-obj = PDF::Object.compose( |%params );
                my Pair $new-entry = self!"register-resource"( $new-obj );
                $new-entry;
        };
        my $entry = $lookup.value but ResourceEntry;
        $entry.key = $lookup.key;
        $entry;
    }

    method resource(PDF::Object $object) {
        my $type = $object.?Type
            // die "not a resource object: {$object.WHAT}";

        my Pair $lookup = self!"find-resource"(sub ($_){$_ === $object}, :$type)
            //  self!"register-resource"( $object );

        my $entry = $lookup.value but ResourceEntry;
        $entry.key = $lookup.key;
        $entry;
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

    method !base-name( PDF::DOM::Type $object ) {
        my $type = $object.?Type
            // die "not a resource object: {$object.WHAT}";

        do given $type {
            when 'Font' {'F'}
            when 'Pattern' {'Pat'}
            when 'XObject' {
                $object.Subtype eq 'Form'
                    ?? 'Fm'
                    !! 'Im';
            }
            default { 'Obj' }
        }
    }

    #| ensure that the object is registered as a page resource. Return a unique
    #| name for it.
    method !register-resource(PDF::Object $object,
                             Str :$base-name = self!"base-name"($object),
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
