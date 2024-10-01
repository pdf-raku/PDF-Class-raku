unit role PDF::Attributes;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;
also does ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;

use ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries;
also does ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries;

use PDF::COS;
use PDF::COS::Dict;
use PDF::COS::Tie;
use PDF::COS::Name;

use PDF::Namespace;

# See PDF 2.0 Table 376 - Standard structure attribute owners
my subset Owner of PDF::COS::Name where 'Layout'|
'List'|
'PrintField'|
'Table'|
'UserProperties'|
'Artifact'|
'XML-1.00'|
'HTML-3.20'|
'HTML-4.01'|
'HTML-5.00'|
'OEB-1.00'|
'RTF-1.05'|
'CSS-1'|
'CSS-2'|
'CSS-3'|
'RDFa-1.10'|
'ARIA-1.1'|
'NSO';
has Owner $.O is entry(:alias<owner>, :required); # The name of the PDF processor creating the attribute data.
has PDF::Namespace $.NS is entry(:alias<namespace=>, :indirect); # (Required if the value of the O entry is NSO; not permitted otherwise; PDF 2.0) An indirect reference to a namespace dictionary defining the namespace that attributes with this attribute object dictionary belong to.

method set-attribute($key, $value) { self{$key} = $value }
method attributes-delegate( Hash $dict) {
    my $owner := $dict<O>;
    if $owner ~~ 'Layout'|'List'|'PrintField'|'Table'|'UserProperties' {
        PDF::COS.loader.find-delegate: 'Attributes', $owner, :base-class(PDF::Attributes)
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

