[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



Table Table 349 – Standard table attributes

### has UInt $.RowSpan

(Optional; not inheritable) The number of rows in the enclosing table that is spanned by the cell. The cell shall expand by adding rows in the block-progression direction specified by the table’s WritingMode attribute. If this entry is absent, a conforming reader assumes a value of 1.

### has UInt $.ColSpan

(Optional; not inheritable) The number of columns in the enclosing table that is spanned by the cell. The cell shall expand by adding columns in the inline-progression direction specified by the table’s WritingMode attribute. If this entry is absent, a conforming reader assumes a value of 1

### has Positional[PDF::COS::ByteString] @.Headers

(Optional; not inheritable; PDF 1.5) An array of byte strings, where each string is the element identifier (see the ID entry in Table 323) for a TH structure element that is used as a header associated with this cell.

### has PDF::Attributes::Table::Scope $.Scope

(Optional; not inheritable; PDF 1.5) A name whose value is one of the following: Row, Column, or Both. This attribute is only be used when the structure type of the element is TH. (see Table 337). It shall reflect whether the header cell applies to the rest of the cells in the row that contains it, the column that contains it, or both the row and the column that contain it.

### has PDF::COS::TextString $.Summary

(Optional; not inheritable; PDF 1.7) A summary of the table’s purpose and structure. This entry is only be used within Table structure elements (see Table 337).

### has PDF::COS::TextString $.Short

(Optional; not inheritable; PDF 2.0) Contains a short form of the content of a TH structure element’s content.

