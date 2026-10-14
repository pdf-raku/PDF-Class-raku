unit class PDF::FontFile;

use PDF::FontStream;
also is PDF::FontStream;

use ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;
also does ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;

use ISO_32000_2::Table_125-Additional_entries_in_an_embedded_font_stream_dictionary;
also does ISO_32000_2::Table_125-Additional_entries_in_an_embedded_font_stream_dictionary;

use PDF::COS::Name;
use PDF::COS::Tie;
use PDF::Class::Defs :FontFileType;
use PDF::Metadata::XML;

has PDF::COS::Name $.Subtype where FontFileType;

use ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;
## also does ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;

use ISO_32000_2::Table_125-Additional_entries_in_an_embedded_font_stream_dictionary;
also does ISO_32000_2::Table_125-Additional_entries_in_an_embedded_font_stream_dictionary;

has UInt $.Length1 is entry; #= (Required for Type 1 and TrueType fonts) The length in bytes of the clear-text portion of the Type 1 font program, or the entire TrueType font program, after it has been decoded using the filters specified by the stream’s Filter entry, if any.
has UInt $.Length2 is entry; #= (Required for Type 1 fonts) The length in bytes of the encrypted portion of the Type 1 font program after it has been decoded using the filters specified by the stream’s Filter entry.
has UInt $.Length3 is entry; #= (Required for Type 1 fonts) The length in bytes of the fixed-content portion of the Type 1 font program after it has been decoded using the filters specified by the stream’s Filter entry. If Length3 is 0, it indicates that the 512 zeros and cleartomark have not been included in the FontFile font program and shall be added by the conforming reader.

has PDF::Metadata::XML $.Metadata is entry; #= (Optional; PDF 1.4) A metadata stream containing metadata for the embedded font program.
