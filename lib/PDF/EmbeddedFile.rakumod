unit role PDF::EmbeddedFile;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::COS::DateString;

use ISO_32000::Table_45-Additional_entries_in_an_embedded_file_stream_dictionary;
also does ISO_32000::Table_45-Additional_entries_in_an_embedded_file_stream_dictionary;

use ISO_32000_2::Table_44-Additional_entries_in_an_embedded_file_stream_dictionary;
also does ISO_32000_2::Table_44-Additional_entries_in_an_embedded_file_stream_dictionary;

has PDF::COS::Name $.Type is entry where 'EmbeddedFile';
has PDF::COS::Name $.Subtype is entry; # (Optional, required in the case of an embedded file stream used as an associated
# file) The subtype of the embedded file. The value of this entry shall conform to the
# MIME media type names defined in Internet RFC 2046,

my role ParamsDict does PDF::COS::Tie::Hash {

    use ISO_32000::Table_46-Entries_in_an_embedded_file_parameter_dictionary;
    also does ISO_32000::Table_46-Entries_in_an_embedded_file_parameter_dictionary;

    use ISO_32000_2::Table_45-Entries_in_an_embedded_file_parameter_dictionary;
    also does ISO_32000_2::Table_45-Entries_in_an_embedded_file_parameter_dictionary;

    has UInt $.Size is entry;
    has PDF::COS::DateString $.CreationDate is entry;
    has PDF::COS::DateString $.ModDate is entry;
    has Hash $.Mac is entry;
    has Str $.CheckSum is entry;
}
has ParamsDict $.Params is entry;

