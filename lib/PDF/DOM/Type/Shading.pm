use v6;

use PDF::Object::Dict;

# /ShadingType 1..7 - the Shading dictionary delegates

class PDF::DOM::Type::Shading
    is PDF::Object::Dict {

    use PDF::Object::Tie;
    subset ShadingTypeInt of Int where 1..7;
    has ShadingTypeInt $!ShadingType is entry;

    has $!ColorSpace is entry(:required);
    has Array $!Background is entry;
    has Array $!BBox is entry;
    has Bool $!AntiAlias is entry;

    # from PDF Spec 1.7 table 4.28
    constant ShadingTypes = <Function Axial Radial FreeForm Lattice Coons Tensor>;
    constant ShadingNames = %( ShadingTypes.pairs.invert );
    method type {'Shading'}
    method subtype { ShadingTypes[ $!ShadingType - 1] }

    #| see also PDF::DOM::Delegator
    method delegate(Hash :$dict!) {

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

    method cb-setup-type( Hash $dict is rw ) {
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
