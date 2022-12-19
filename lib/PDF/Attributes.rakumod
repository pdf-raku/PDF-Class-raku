use PDF::COS::Tie::Hash;
role PDF::Attributes does PDF::COS::Tie::Hash {
    # use  ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;
    # also does ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;
    use PDF::COS;
    use PDF::COS::Dict;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    has PDF::COS::Name $.O is entry(:alias<owner>, :required);
    method set-attribute($key, $value) { self{$key} = $value }
    method attributes-delegate( PDF::COS::Dict $dict) {
        with $dict<O> -> $owner {
             PDF::COS.loader.find-delegate( 'Attributes', $owner, :base-class(PDF::Attributes) );
        }
        else {
            PDF::Attributes;
        }
        
    }
    proto sub coerce-attributes($, PDF::Attributes) is export(:coerce-attributes) {*}
    multi sub coerce-attributes(Hash $dict, PDF::Attributes $attributes) {
        my PDF::Attributes:U $role = $attributes.attributes-delegate( $dict );
	PDF::COS.coerce: $dict, $role;
    }
    multi sub coerce-attributes($_, PDF::Attributes) {
        warn "unable to coerce struct attributes: {.raku}";
        $_;
    }
    method coerce-attributes(Hash $dict) {
        coerce-attributes($dict, PDF::Attributes);
    }
    method Hash {
        my @keys = self.keys.grep: * ne 'O';
        my % = @keys.map: { $_ => self{$_} }
    }
}
