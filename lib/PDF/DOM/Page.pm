use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::Object::Inheritance;
use PDF::DOM;
use PDF::DOM::XObject::Image;
use PDF::DOM::XObject::Form;
use PDF::DOM::Font;
use PDF::DOM::Util::Content;
use PDF::Writer;

# /Type /Page - describes a single PDF page

class PDF::DOM::Page
    is PDF::Object::Dict
    does PDF::Object::Inheritance
    does PDF::DOM {

    has PDF::DOM::Util::Content $.pre-gfx = PDF::DOM::Util::Content.new( :parent(self) ); #| prepended graphics
    has PDF::DOM::Util::Content $.gfx = PDF::DOM::Util::Content.new( :parent(self) ); #| appended graphics

    method Parent is rw { self<Parent> }
    method Resources is rw { self<Resources> }
    method MediaBox is rw { self<MediaBox> }
    method Contents is rw { self<Contents> }

    #| contents may either be a stream on an array of streams
    method contents {
        given $.Contents {
            when !.defined   { [] }
            when Array       { $_ }
            when Hash | Pair { [$_] }
            default { die "unexpected page content: {.perl}" }
        }
    }

    #| produce an XObject form for this page
    method to-xobject() {
        my $contents = self.Contents;
        my %params = $contents.get-stream();
        my $xobject = PDF::DOM::XObject::Form.new( |%params );
        $xobject.Resources = self.find-prop('Resources');
        $xobject.BBox = self.find-prop('MediaBox');

        $xobject;
    }

    multi method register-resource( PDF::DOM::XObject::Form $object) {
        self!"register-resource"( $object, :base-name<Fm>, );
    }

    multi method register-resource( PDF::DOM::XObject::Image $object) {
        self!"register-resource"( $object, :base-name<Im>, );
    }

    multi method register-resource( PDF::DOM::Font $object) {
        self!"register-resource"( $object, :base-name<F>, );
    }

    #| ensure that the object is registered as a page resource. Return a unique
    #| name for it.
    method !register-resource(PDF::Object $object, Str :$base-name = <Obj>, :$type = $object.Type) {
        my $id = $object.id;
        my $resources = self.find-prop('Resources')
            // do {
                self.Resources = {};
                self.Resources
        };

        $resources{$type} //= {};

        for $resources{$type}.keys {
            my $xo-id = $resources{$type}{$_}.id;

            # we've already got that object, thanks!
            return $_
                if $xo-id eq $id;
        }

        my $name = (1..*).map({$base-name ~ $_}).first({ $resources{$type}{$_}:!exists });
        $resources{$type}{$name} = $object;

        self.compose( :$name );
    }

    method cb-finish {

        if $!pre-gfx.ops || $!gfx.ops {

            # wrap new content in save ... restore - for safety's sake
            for $!pre-gfx, $!gfx {
                if .defined && .ops {
                    .save(:prepend);
                    .restore;
                }
            }

            # also wrap any existing content in save ... restore
            my @contents = @$.contents;
            if +@contents {
                # wrap ex
                $!pre-gfx.save;
                $!gfx.restore(:prepend);
            }

            my $writer = PDF::Writer.new;

            @contents.unshift: PDF::Object::Stream.new( :encoded( $writer.write(:content($!pre-gfx.ops)) ) )
                if $!pre-gfx.ops;

            @contents.push: PDF::Object::Stream.new( :encoded( $writer.write(:content($!gfx.ops)) ) )
                if $!gfx.ops;

            self<Contents> = @contents.item;
        }

    }

}

