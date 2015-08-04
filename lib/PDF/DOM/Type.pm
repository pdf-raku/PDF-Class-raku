use v6;

use PDF::Object;
use PDF::Object::Type;
use PDF::DOM::Delegator;

# autoload from PDF::DOM::Type

role PDF::DOM::Type
    does PDF::Object::Type {

    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::DOM::Type::Catalog should have /Type = /Catalog
    method type    {self<Type>}
    method subtype {self<Subtype> // self<S>}

    method cb-init {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
                my Str $type-name = ~$0;

                if self<Type>:!exists {
                    self<Type> = PDF::Object.coerce( :name($type-name) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /Type /{self<Type>}"
                        unless self<Type> eq $type-name;
                }

                if $1 {
                    my Str $subtype-name = ~$1;

                    if self<Subtype>:!exists {
                        self<Subtype> = PDF::Object.coerce( :name($subtype-name) );
                    }
                    else {
                        # /Subtype already set. check it agrees with the class name
                        die "conflict between class-name $class-name ($subtype-name) and dictionary /Subtype /{self<Subtype>.value}"
                            unless self<Subtype> eq $subtype-name;
                    }
                }

                last;
            }
        }

    }

}
