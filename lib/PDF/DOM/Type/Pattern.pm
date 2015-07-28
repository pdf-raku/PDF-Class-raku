use v6;

use PDF::Object::Stream;
use PDF::DOM::Contents;
use PDF::DOM::Resources;

role PDF::DOM::Type::Pattern
    does PDF::DOM::Contents
    does PDF::DOM::Resources {

    use PDF::Object::Tie;
    use PDF::Object::Name;
    #| /Type entry is optional, but should be /Pattern when present
    has PDF::Object::Name $!Type is entry;
    subset PatternTypeInt of Int where 1|2;
    has PatternTypeInt $!PatternType is entry(:required);  #| (Required) A code identifying the type of pattern that this dictionary describes; must be 1 for a tiling pattern, or 2 for a shading pattern.
    has Array $!Matrix is entry;                           #| (Optional) An array of six numbers specifying the pattern matrix (see Section 4.6.1, “General Properties of Patterns”). Default value: the identity matrix [ 1 0 0 1 0 0 ].

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

    method cb-init {

        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
                my Str $type-name = ~$0;

                if self<Type>:exists {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /Type /{self<Type>}"
                        unless self<Type> eq $.type;
                }

                if $1 {
                    my Str $subtype = ~$1;
		    die "$class-name has unknown subtype $subtype"
			unless PatternTypes{$subtype}:exists;

                    if self<PatternType>:!exists {
                        self<PatternType> = PatternTypes{$subtype};
                    }
                    else {
                        # /Subtype already set. check it agrees with the class name
                        die "conflict between class-name $class-name ($subtype) and /PatternType /{self<PatternType>.value}"
                            unless self<PatternType> == PatternTypes{$subtype};
                    }
                }

                last;
            }
        }

    }

}
