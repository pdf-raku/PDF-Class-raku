use v6;

use PDF::Object::Stream;
use PDF::DOM::Contents;
use PDF::DOM::Resources;

role PDF::DOM::Type::Pattern
    does PDF::DOM::Contents
    does PDF::DOM::Resources {

    #| /Type entry is optional, but should be /Pattern when present
    has Str:_ $!Type; method Type { self.tie($!Type) };
    subset PatternTypeInt of Int where 1|2;
    has PatternTypeInt $!PatternType; method PatternType { self.tie($!PatternType) };
    has Array:_ $!Matrix; method Matrix { self.tie($!Matrix) };

    constant PatternTypes = %( :Tiling(1), :Shading(2) );
    constant PatternNames = %( PatternTypes.pairs.invert );

    method type    { 'Pattern' }
    method subtype { PatternNames[ self<PatternType> ] }

    #| see also PDF::DOM::Delegator
    method delegate(Hash :$dict!) {

	use PDF::Object::Util :from-ast;
	my Int $type-int = from-ast $dict<PatternType>;

	unless $type-int ~~ PatternTypeInt {
	    note "unknown /PatternType $dict<PatternType> - supported range is 1..7";
	    return self.WHAT;
	}

	my $subtype = PatternNames{~$type-int};

	require ::(self.WHAT.^name)::($subtype);
	return  ::(self.WHAT.^name)::($subtype);
    }

    method cb-setup-type( Hash $dict is rw ) {

        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
                my Str $type-name = ~$0;

                if $dict<Type>:exists {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /Type /{$dict<Type>}"
                        unless $dict<Type> eq $.type;
                }

                if $1 {
                    my Str $subtype = ~$1;
		    die "$class-name has unknown subtype $subtype"
			unless PatternTypes{$subtype}:exists;

                    if $dict<PatternType>:!exists {
                        $dict<PatternType> = PatternTypes{$subtype};
                    }
                    else {
                        # /Subtype already set. check it agrees with the class name
                        die "conflict between class-name $class-name ($subtype) and /PatternType /{$dict<PatternType>.value}"
                            unless $dict<PatternType> == PatternTypes{$subtype};
                    }
                }

                last;
            }
        }

    }

}
