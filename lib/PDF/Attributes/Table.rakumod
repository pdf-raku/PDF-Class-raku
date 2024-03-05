#| Table Table 349 – Standard table attributes
unit role PDF::Attributes::Table;

use PDF::Attributes;
also does PDF::Attributes;

use PDF::COS::Tie;
use PDF::COS::ByteString;
use PDF::COS::TextString;
use PDF::COS::Name;

use ISO_32000::Table_349-Standard_table_attributes;
also does ISO_32000::Table_349-Standard_table_attributes;

use ISO_32000_2::Table_384-Standard_table_attributes;
also does ISO_32000_2::Table_384-Standard_table_attributes;

has UInt $.RowSpan is entry;	# (Optional; not inheritable) The number of rows in the enclosing table that is spanned by the cell. The cell shall expand by adding rows in the block-progression direction specified by the table’s WritingMode attribute. If this entry is absent, a conforming reader assumes a value of 1.
	# This entry is only be used when the table cell has a structure type of TH or TD or one that is role mapped to structure type TH or TD (see Table 337).

has UInt $.ColSpan is entry;	# (Optional; not inheritable) The number of columns in the enclosing table that is spanned by the cell. The cell shall expand by adding columns in the inline-progression direction specified by the table’s WritingMode attribute. If this entry is absent, a conforming reader assumes a value of 1
	# This entry is only be used when the table cell has a structure type of TH or TD or one that is role mapped to structure types TH or TD (see Table 337).

has PDF::COS::ByteString @.Headers is entry;	# (Optional; not inheritable; PDF 1.5) An array of byte strings, where each string is the element identifier (see the ID entry in Table 323) for a TH structure element that is used as a header associated with this cell.
	# This attribute may apply to header cells (TH) as well as data cells (TD) (see Table 337). Therefore, the headers associated with any cell is those in its Headers array plus those in the Headers array of any TH cells in that array, and so on recursively.

my subset Scope of PDF::COS::Name where 'Row'|'Column'|'Both';
has Scope $.Scope is entry;	# (Optional; not inheritable; PDF 1.5) A name whose value is one of the following: Row, Column, or Both. This attribute is only be used when the structure type of the element is TH. (see Table 337). It shall reflect whether the header cell applies to the rest of the cells in the row that contains it, the column that contains it, or both the row and the column that contain it.

has PDF::COS::TextString $.Summary is entry;	# (Optional; not inheritable; PDF 1.7) A summary of the table’s purpose and structure. This entry is only be used within Table structure elements (see Table 337).
	# NOTE For use in non-visual rendering such as speech or braille

has PDF::COS::TextString $.Short is entry;      # (Optional; not inheritable; PDF 2.0) Contains a short form of the content of a TH structure element’s content.
