use v6;

use PDF::Object::Array;
use PDF::Object::Tie::Array;

class PDF::DOM::Array::ColorSpace
    is PDF::Object::Array {

    has Str $!type;  method type { self.tie( 0, $!type ) }
    has Hash $!dict; method dict { self.tie( 1, $!dict ) }

    constant ColorSpaceTypes = <CalGray CalRGB Lab>;
    constant ColorSpaceNames = %( ColorSpaceTypes.pairs.invert );

    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::DOM::Type::Catalog should have /Type = /Catalog
    method cb-setup-type( Array $array is rw ) {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Array::' (\w+) '::' (\w+) $/ {

		die "bad class-name $class-name"
		    unless ~$0 eq 'ColorSpace';
		
                my Str $type-name = ~$1;

                if ! $array[0].defined {
                    $array[0] = PDF::Object.compose( :name($type-name) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /Type /{$array[0]}"
                        unless $array[0] eq $type-name;
                }

                last;
            }
	    $array[1] //= {}
        }
    }
}
