use v6;

use PDF::Object::Stream;

# /FunctionType 1..7 - the Function dictionary delegates

class PDF::DOM::Type::Function
    is PDF::Object::Stream {

    use PDF::Object::Tie;

    subset FunctionTypeInt of Int where 0|2|3|4;

    has FunctionTypeInt $!FunctionType is entry(:required);
    has Array $!Domain is entry(:required);
    has Array $!Range is entry;

    # from PDF Spec 1.7 table 3.35
    constant FunctionTypes = <Sampled n/a Exponential Stitching PostScript>;
    constant FunctionNames = %( FunctionTypes.pairs.invert );
    method type {'Function'}
    method subtype { FunctionTypes[ $!FunctionType ] }

    #| see also PDF::DOM::Delegator
    method delegate(Hash :$dict!) {

	use PDF::Object::Util :from-ast;
	my Int $function-type-int = from-ast $dict<FunctionType>;

	unless $function-type-int ~~ FunctionTypeInt {
	    note "unknown /FunctionType $dict<FunctionType> - supported range is 0,2,3,4";
	    return self.WHAT;
	}

	my $function-type = FunctionTypes[$function-type-int];

	require ::(self.WHAT.^name)::($function-type);
	return  ::(self.WHAT.^name)::($function-type);
    }

    method cb-setup-type( Hash $dict is rw ) {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
		my Str $type = ~$0;
		my Str $function-type = ~$1
		    if $1;

		die "invalid function class: $class-name"
		    unless $type eq $.type
		    && $function-type
		    && (FunctionNames{ $function-type }:exists);

		my FunctionTypeInt $function-type-int = FunctionNames{ $function-type };

		if $dict<FunctionType>:!exists {
		    $dict<FunctionType> = $function-type-int;
		}
		else {
		    # /Subtype already set. check it agrees with the class name
		    die "conflict between class-name $class-name /FunctionType. Expected $function-type-int, got  $dict<FunctionType>"
			unless $dict<FunctionType> == $function-type-int;
		}

                last;
            }
        }

    }
}
