use v6;

use PDF::Object::Dict;

# /ShadingType 1..7 - the Shading dictionary delegates

class PDF::DOM::Type::Shading
    is PDF::Object::Dict {

    subset ShadingTypeInt of Int where 1..7;
    has ShadingTypeInt $!ShadingType; method ShadingType { self.tie($!ShadingType) };

    has $!ColorSpace; method ColorSpace { self.tie($!ColorSpace) };
    has Array:_ $!Background; method Background { self.tie($!Background) };
    has Array:_ $!BBox; method BBox { self.tie($!BBox) };
    has Bool:_ $!AntiAlias; method AntiAlias { self.tie($!AntiAlias) };

    # from PDF Spec 1.7 table 4.28
    constant ShadingTypes = <Function Axial Radial FreeForm Lattice Coons Tensor>;
    constant ShadingNames = %( ShadingTypes.pairs.invert );

    #| see also PDF::DOM::Delegator
    method delegate(Hash :$dict!) {

	use PDF::Object::Util :from-ast;
	my Int $shading-type-int = from-ast $dict<ShadingType>;

	unless $shading-type-int ~~ ShadingTypeInt {
	    note "unknown /ShadingType $dict<ShadingType> - supported range is 1..7";
	    return self.WHAT;
	}

	my $shading-type = ShadingTypes[$shading-type-int - 1];

	require ::(self.WHAT.^name)::($shading-type);
	return  ::(self.WHAT.^name)::($shading-type);
    }

    method cb-setup-type( Hash $dict is rw ) {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
		my Str $type = ~$0;
		my Str $shading-type = ~$1
		    if $1;

		die "invalid shading class: $class-name"
		    unless $type eq 'Shading'
		    && $shading-type
		    && (ShadingNames{ $shading-type }:exists);

		my ShadingTypeInt $shading-type-int = ShadingNames{ $shading-type } + 1;

		if $dict<ShadingType>:!exists {
		    $dict<ShadingType> = $shading-type-int;
		}
		else {
		    # /Subtype already set. check it agrees with the class name
		    die "conflict between class-name $class-name /ShadingType. Expected $shading-type-int, got  $dict<ShadingType>"
			unless $dict<ShadingType> == $shading-type-int;
		}

                last;
            }
        }

    }
}
