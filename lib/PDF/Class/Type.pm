use v6;

role PDF::Class::Type[$type-entry = 'Type', $subtype-entry = 'Subtype'] {

    use PDF::Class::Loader;
    method type    is rw { self{$_} with $type-entry }
    method subtype is rw { self{$_} with $subtype-entry }

}
