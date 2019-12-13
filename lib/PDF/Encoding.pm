use v6;

use PDF::COS::Tie::Hash;

#| /Type /Encoding
role PDF::Encoding
    does PDF::COS::Tie::Hash {

    # use ISO_32000::Table_114-Entries_in_an_encoding_dictionary;
    # also does ISO_32000::Table_114-Entries_in_an_encoding_dictionary;

    use PDF::COS::Tie;
    use PDF::COS::Name;

    has PDF::COS::Name $.Type is entry where 'Encoding';
    has PDF::COS::Name $.BaseEncoding is entry; # (Optional) The base encoding—that is, the encoding from which the Differences entry (if present) describes differences.
    has @.Differences is entry;                 # (Optional; not recommended with TrueType fonts) An array describing the differences from the encoding specified by BaseEncoding or, if BaseEncoding is absent, from an implicit base encoding.

}
