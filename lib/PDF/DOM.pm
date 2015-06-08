use v6;

use PDF::Object::DOM;
PDF::Object::DOM.install-handler('PDF::DOM');

# autoload from PDF::DOM

role PDF::DOM
    does PDF::Object::DOM {

    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::DOM::Catalog should have /Type = /Catalog
    method cb-setup-type( Hash $dict is rw ) {
        for self.^mro {
            my $class-name = .^name;

            if $class-name ~~ /^ 'PDF::DOM::' (\w+) ['::' (\w+)]? $/ {
                my $type-name = ~$0;

                if $dict<Type>:!exists {
                    $dict<Type> = PDF::Object.compose( :name($type-name) );
                }
                else {
                    # /Type already set. check it agrees with the class name
                    die "conflict between class-name $class-name ($type-name) and dictionary /Type /{$dict<Type>}"
                        unless $dict<Type> eq $type-name;
                }

                if $1 {
                    my $subtype-name = ~$1;

                    if $dict<Subtype>:!exists {
                        $dict<Subtype> = PDF::Object.compose( :name($subtype-name) );
                    }
                    else {
                        # /Subtype already set. check it agrees with the class name
                        die "conflict between class-name $class-name ($subtype-name) and dictionary /Subtype /{$dict<Subtype>.value}"
                            unless $dict<Subtype> eq $subtype-name;
                    }
                }

                last;
            }
        }

    }

}
