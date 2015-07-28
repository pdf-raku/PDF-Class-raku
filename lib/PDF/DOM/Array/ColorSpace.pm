use v6;

use PDF::Object::Array;
use PDF::Object::Tie;
use PDF::Object::Tie::Array;

class PDF::DOM::Array::ColorSpace
    is PDF::Object::Array {

    method type {'ColorSpace'}
    method subtype {$.Subtype}
    use PDF::Object::Name;
    has PDF::Object::Name $!Subtype is index(0);
    has Hash $!Dict is index(1);

    constant ColorSpaceTypes = <CalGray CalRGB Lab>;
    constant ColorSpaceNames = %( ColorSpaceTypes.pairs.invert );

    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::DOM::Type::Catalog should have /Type = /Catalog
    method cb-init {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Array::' (\w+) '::' (\w+) $/ {

		die "bad class-name $class-name"
		    unless ~$0 eq $.type;
		
                my Str $subtype = ~$1;

                if ! self.Subtype {
                    self.Subtype = PDF::Object.compose( :name($subtype) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($subtype) and array[0] type /{self[0]}"
                        unless self.Subtype eq $subtype;
                }
                last;
            }
	    self.Dict //= {};
        }
    }
}
