use v6;

role PDF::Class::Type[$type-entry = 'Type', $subtype-entry = 'Subtype'] {

    use PDF::Class::Loader;
    #| enforce tie-ins between /Type, /Subtype & the class name. e.g.
    #| PDF::Catalog should have /Type = /Catalog
    method type    is rw { self{$type-entry} }
    method subtype is rw { self{$subtype-entry} }

}
