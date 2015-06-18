use v6;

use PDF::DOM::Composition::Content;
use PDF::DOM::Type::XObject;
use PDF::DOM::Type::Font;

#| this role is applied to PDF::DOM::Type::Pages and PDF::DOM::Type::XObject::Form
role PDF::DOM::Composition {

    has PDF::DOM::Composition::Content $.pre-gfx = PDF::DOM::Composition::Content.new( :parent(self) ); #| prepended graphics
    has PDF::DOM::Composition::Content $.gfx     = PDF::DOM::Composition::Content.new( :parent(self) ); #| appended graphics

    method Resources is rw { self<Resources> }
    method MediaBox is rw { self<MediaBox> }
    method Contents is rw { self<Contents> }

    multi method register-resource( PDF::DOM::Type::XObject $object) {
        my $base-name = do given $object.Subtype {
            when 'Form'  {'Fm'}
            when 'Image' {'Im'}
            default {die "Unhandled XObject.Subtype: $_"}
        }
        self!"register-resource"( $object, :$base-name, );
    }

    multi method register-resource( PDF::DOM::Type::Font $object) {
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

        my $resource = $resources{$type}.keys.first( -> $name {
            my $xo-id = $resources{$type}{$name}.id;
            # we've already got that object, thanks!
            $xo-id eq $id;
        });

        $resource //= do {
            my $name = (1..*).map({$base-name ~ $_}).first({ $resources{$type}{$_}:!exists });
            $resources{$type}{$name} = $object;

            self.compose( :$name );
        };

        $resource;
    }

}
