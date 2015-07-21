use v6;

use PDF::Object::Array;
use PDF::Object::Tie::Array;

class PDF::DOM::Array::ColorSpace
    is PDF::Object::Array {

    method type {'ColorSpace'}
    has Str $!subtype;  method subtype { self.tie( 0, $!subtype ) }
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
		    unless ~$0 eq $.type;
		
                my Str $subtype = ~$1;

                if ! $array[0].defined {
                    $array[0] = PDF::Object.compose( :name($subtype) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($subtype) and array[0] type /{$array[0]}"
                        unless $array[0] eq $subtype;
                }

                last;
            }
	    $array[1] //= {}
        }
    }
}
