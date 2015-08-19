use v6;

use PDF::Object;
use PDF::Object::Type;
use PDF::DOM::Delegator;

# autoload from PDF::DOM::Type

role PDF::DOM::Type[$type-entry = 'Type', $subtype-entry = 'Subtype']
    does PDF::Object::Type {

    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::DOM::Type::Catalog should have /Type = /Catalog
    method type    { self{$type-entry} }
    method subtype { self{$subtype-entry} }

    method cb-init {
        for self.^mro {
            my Str $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::Type::' (\w+) ['::' (\w+)]? $/ {
                my Str $type-name = ~$0;

                if self{$type-entry}:!exists {
                    self{$type-entry} = PDF::Object.coerce( :name($type-name) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /$type-entry /{self{$type-entry}}"
                        unless self{$type-entry} eq $type-name;
                }

                if $1 {
                    my Str $subtype-name = ~$1;

                    if self{$subtype-entry}:!exists {
                        self{$subtype-entry} = PDF::Object.coerce( :name($subtype-name) );
                    }
                    else {
                        # /Subtype already set. check it agrees with the class name
                        die "conflict between class-name $class-name ($subtype-name) and dictionary /$subtype-entry /{self{$subtype-entry}}"
                            unless self{$subtype-entry} eq $subtype-name;
                    }
                }

                last;
            }
        }

    }

}
