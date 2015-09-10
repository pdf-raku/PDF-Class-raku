use v6;

use PDF::Object::Dict;

# /ShadingType 1..7 - the Shading dictionary delegates

class PDF::DOM::Type::Shading
    is PDF::Object::Dict {

    use PDF::Object::Tie;
    use PDF::Object::Array;
    use PDF::Object::Name;
    subset ShadingTypeInt of Int where 1..7;
    has ShadingTypeInt $.ShadingType is entry;

    # see [PDF 1.7 TABLE 4.28 Entries common to all shading dictionaries]
    subset NameOrArray of Any where PDF::Object::Array | PDF::Object::Name;
    has NameOrArray $.ColorSpace is entry(:required); #| (Required) The color space in which color values are expressed.
    has Array $.Background is entry;                  #| (Optional) An array of color components appropriate to the color space, specifying a single background color value.
    has Array $.BBox is entry;                        #| (Optional) An array of four numbers giving the left, bottom, right, and top coordinates, respectively, of the shading’s bounding box
    has Bool $.AntiAlias is entry;                    #| (Optional) A flag indicating whether to filter the shading function to prevent aliasing artifacts.

    # from PDF Spec 1.7 table 4.28
    constant ShadingTypes = <Function Axial Radial FreeForm Lattice Coons Tensor>;
    constant ShadingNames = %( ShadingTypes.pairs.invert );
    method type {'Shading'}
    method subtype { ShadingTypes[ $.ShadingType - 1] }

    #| see also PDF::DOM::Delegator
    method delegate-shading(Hash :$dict!) {

	use PDF::Object::Util :from-ast;
	my Int $type-int = from-ast $dict<ShadingType>;

	unless $type-int ~~ ShadingTypeInt {
	    note "unknown /ShadingType $dict<ShadingType> - supported range is 1..7";
	    return self.WHAT;
	}

	my $type = ShadingTypes[$type-int - 1];

	require ::(self.WHAT.^name)::($type);
	return  ::(self.WHAT.^name)::($type);
    }

    method cb-init {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
		my Str $type = ~$0;
		my Str $shading-type = ~$1
		    if $1;

		die "invalid shading class: $class-name"
		    unless $type eq $.type
		    && $shading-type
		    && (ShadingNames{ $shading-type }:exists);

		my ShadingTypeInt $shading-type-int = ShadingNames{ $shading-type } + 1;

		if self<ShadingType>:!exists {
		    self<ShadingType> = $shading-type-int;
		}
		else {
		    # /Subtype already set. check it agrees with the class name
		    die "conflict between class-name $class-name /ShadingType. Expected $shading-type-int, got  self<ShadingType>"
			unless self<ShadingType> == $shading-type-int;
		}

                last;
            }
        }

    }
}
