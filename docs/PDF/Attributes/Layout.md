[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Attributes::Layout::Common_attributes::Placement $.Placement

(Optional; not inheritable) The positioning of the element with respect to the enclosing reference area and other content:

### has PDF::Attributes::Layout::Common_attributes::WritingMode $.WritingMode

(Optional; inheritable) The directions of layout progression for packing of ILSEs (inline progression) and stacking of BLSEs (block progression):

### has Positional[PDF::Attributes::Layout::RGB] @.BackgroundColor

(Optional; not inheritable; PDF 1.5) The colour to be used to fill the background of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the element is treated as if it were transparent.

### has Positional[PDF::Attributes::Layout::RGB] @.BorderColor

(Optional; inheritable; PDF 1.5) The colour of the border drawn on the edges of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value of each edge is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. There are two forms: A single array of three numbers representing the RGB values to apply to all four edges. An array of four arrays, each specifying the RGB values for one edge of the border, in the order of the before, after, start, and end edges. A value of null for any of the edges means that it is not drawn. If this attribute is not specified, the border colour for this element is the current text fill colour in effect at the start of its associated content.

### has Positional[PDF::Attributes::Layout::BorderStyle] @.BorderStyle

(Optional; not inheritable; PDF 1.5) The style of an element’s border. Specifies the stroke pattern of each edge of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). There are two forms:

### has Positional[Numeric] @.BorderThickness

(Optional; inheritable; PDF 1.5) The thickness of the border drawn on the edges of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value of each edge is a positive number in default user space units representing the border’s thickness (a value of 0 indicates that the border is not drawn). There are two forms:

### has Positional[Numeric] @.Padding

(Optional; not inheritable; PDF 1.5) Specifies an offset to account for the separation between the element’s content rectangle and the surrounding border (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”). A positive value enlarges the background area; a negative value trims it, possibly allowing the border to overlap the element’s text or graphic.

### has Positional[PDF::Attributes::Layout::RGB] @.Color

(Optional; inheritable; PDF 1.5) The colour to be used for drawing text and the default value for the colour of table borders and text decorations. The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the border colour for this element is the current text fill colour in effect at the start of its associated content.



Table 344 – Additional standard layout attributes specific to block-level structure elements

### has Numeric $.SpaceBefore

(Optional; not inheritable) The amount of extra space preceding the before edge of the BLSE, measured in default user space units in the block-progression direction. This value is added to any adjustments induced by the LineHeight attributes of ILSEs within the first line of the BLSE (see “Layout Attributes for ILSEs” in 14.8.5.4, “Layout Attributes”). If the preceding BLSE has a SpaceAfter attribute, the greater of the two attribute values is used. Default value: 0. This attribute is disregarded for the first BLSE placed in a given reference area.

### has Numeric $.SpaceAfter

(Optional; not inheritable) The amount of extra space following the after edge of the BLSE, measured in default user space units in the block-progression direction. This value is added to any adjustments induced by the LineHeight attributes of ILSEs within the last line of the BLSE (see 14.8.5.4, “Layout Attributes”). If the following BLSE has a SpaceBefore attribute, the greater of the two attribute values is used. Default value: 0. This attribute is disregarded for the last BLSE placed in a given reference area.

### has Numeric $.StartIndent

(Optional; inheritable) The distance from the start edge of the reference area to that of the BLSE, measured in default user space units in the inline-progression direction. This attribute applies only to structure elements with a Placement attribute of Block or Start (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). The attribute is disregarded for elements with other Placement values. Default value: 0. A negative value for this attribute places the start edge of the BLSE outside that of the reference area. The results are implementation- dependent and may not be supported by all conforming products that process Tagged PDF or by particular export formats. If a structure element with a StartIndent attribute is placed adjacent to a floating element with a Placement attribute of Start, the actual value used for the element’s starting indent is its own StartIndent attribute or the inline extent of the adjacent floating element, whichever is greater. This value may be further adjusted by the element’s TextIndent attribute, if any.

### has Numeric $.EndIndent

(Optional; inheritable) The distance from the end edge of the BLSE to that of the reference area, measured in default user space units in the inline-progression direction. This attribute applies only to structure elements with a Placement attribute of Block or End (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). The attribute is disregarded for elements with other Placement values. Default value: 0. A negative value for this attribute places the end edge of the BLSE outside that of the reference area. The results are implementation- dependent and may not be supported by all conforming products that process Tagged PDF or by particular export formats. If a structure element with an EndIndent attribute is placed adjacent to a floating element with a Placement attribute of End, the actual value used for the element’s ending indent is its own EndIndent attribute or the inline extent of the adjacent floating element, whichever is greater.

### has Numeric $.TextIndent

(Optional; inheritable; applies only to some BLSEs) The additional distance, measured in default user space units in the inline- progression direction, from the start edge of the BLSE, as specified by StartIndent, to that of the first line of text. A negative value indicates a hanging indent. Default value: 0. This attribute applies only to paragraphlike BLSEs and those of structure types Lbl (Label), LBody (List body), TH (Table header), and TD (Table data), provided that they contain content other than nested BLSEs.

### has PDF::Attributes::Layout::TextAlign $.TextAlign

(Optional; inheritable; applies only to BLSEs containing text) The alignment, in the inline-progression direction, of text and other content within lines of the BLSE:

### has Positional[Numeric] @.BBox

(Optional for Annot; required for any figure or table appearing in its entirety on a single page; not inheritable) An array of four numbers in default user space units that shall give the coordinates of the left, bottom, right, and top edges, respectively, of the element’s bounding box (the rectangle that completely encloses its visible content). This attribute applies to any element that lies on a single page and occupies a single rectangle.

### has PDF::Attributes::Layout::NumericOrAuto $.Width

(Optional; not inheritable; illustrations, tables, table headers, and table cells only; is used for table cells) The width of the element’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”), measured in default user space units in the inline-progression direction. This attribute applies only to elements of structure type Figure, Formula, Form, Table, TH (Table header), or TD (Table data). The name Auto in place of a numeric value indicates that no specific width constraint is to be imposed; the element’s width is determined by the intrinsic width of its content. Default value: Auto.

### has PDF::Attributes::Layout::NumericOrAuto $.Height

(Optional; not inheritable; illustrations, tables, table headers, and table cells only) The height of the element’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”), measured in default user space units in the block-progression direction. This attribute applies only to elements of structure type Figure, Formula, Form, Table, TH (Table header), or TD (Table data). The name Auto in place of a numeric value indicates that no specific height constraint is to be imposed; the element’s height is determined by the intrinsic height of its content. Default value: Auto.

### has PDF::Attributes::Layout::BLSE_Attributes::BlockAlign $.BlockAlign

(Optional; inheritable; table cells only) The alignment, in the block- progression direction, of content within the table cell:

### has PDF::Attributes::Layout::BLSE_Attributes::InlineAlign $.InlineAlign

(Optional; inheritable; table cells only) The alignment, in the inline- progression direction, of content within the table cell:

### has Positional[PDF::Attributes::Layout::BorderStyle] @.TBorderStyle

(Optional; inheritable; PDF 1.5) The style of the border drawn on each edge of a table cell. Allowed values is the same as those specified for BorderStyle (see Table 343). If both TBorderStyle and BorderStyle apply to a given table cell, BorderStyle shall supersede TBorderStyle. Default value: None.

### has Positional[Int] @.TPadding

(Optional; inheritable; PDF 1.5) Specifies an offset to account for the separation between the table cell’s content rectangle and the surrounding border (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”). If both TPadding and Padding apply to a given table cell, Padding shall supersede TPadding. A positive value shall enlarge the background area; a negative value shall trim it, and the border may overlap the element’s text or graphic. The value is either a single number representing the width of the padding, in default user space units, that applies to all four edges of the table cell or a 4-entry array representing the padding width for the before edge, after edge, start edge, and end edge, respectively, of the content rectangle. Default value: 0.



Table 345 – Standard layout attributes specific to inline-level structure elements

### has Numeric $.BaselineShift

(Optional; not inheritable) The distance, in default user space units, by which the element’s baseline is shifted relative to that of its parent element. The shift direction is the opposite of the block-progression direction specified by the prevailing WritingMode attribute (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). Thus, positive values shall shift the baseline toward the before edge and negative values toward the after edge of the reference area (upward and downward, respectively, in Western writing systems). Default value: 0. The shifted element may be a superscript, a subscript, or an inline graphic. The shift applies to the element, its content, and all of its descendants. Any further baseline shift applied to a child of this element is measured relative to the shifted baseline of this (parent) element.

### has PDF::Attributes::Layout::ILSE_Attributes::LineHeight $.LineHeight

(Optional; inheritable) The element’s preferred height, measured in default user space units in the block-progression direction. The height of a line is determined by the largest LineHeight value for any complete or partial ILSE that it contains.

### has PDF::Attributes::Layout::ILSE_Attributes::TextPosition $.TextPosition

Optional; inheritable; PDF 2.0) The position of the element relative the immediately surrounding content.

### has Positional[PDF::Attributes::Layout::RGB] @.TextDecorationColor

(Optional; inheritable; PDF 1.5) The colour to be used for drawing text decorations. The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the border colour for this element is the current fill colour in effect at the start of its associated content.

### has Numeric $.TextDecorationThickness

(Optional; inheritable; PDF 1.5) The thickness of each line drawn as part of the text decoration. The value is a non-negative number in default user space units representing the thickness (0 is interpreted as the thinnest possible line). If this attribute is not specified, it is derived from the current stroke thickness in effect at the start of the element’s associated content, transformed into default user space units.

### has PDF::Attributes::Layout::ILSE_Attributes::TextDecorationType $.TextDecorationType

(Optional; not inheritable) The text decoration, if any, to be applied to the element’s text.

### has PDF::Attributes::Layout::ILSE_Attributes::RubyAlign $.RubyAlign

(Optional; inheritable; PDF 1.5) The justification of the lines within a ruby assembly:

### has PDF::Attributes::Layout::ILSE_Attributes::RubyPosition $.RubyPosition

(Optional; inheritable; PDF 1.5) The placement of the RT structure element relative to the RB element in a ruby assembly:

### has PDF::Attributes::Layout::NumericOrAuto $.GlyphOrientationVertical

(Optional; inheritable; PDF 1.5) Specifies the orientation of glyphs when the inline-progression direction is top to bottom or bottom to top.



Standard Column atributes

### has Int $.ColumnCount

(Optional; not inheritable; PDF 1.6) The number of columns in the content of the grouping element. Default value: 1.

### has Positional[Numeric] @.ColumnGap

(Optional; not inheritable; PDF 1.6) The desired space between adjacent columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the space between all columns. If the value is an array, it contains numbers, the first element specifying the space between the first and second columns, the second specifying the space between the second and third columns, and so on. If there are fewer than ColumnCount - 1 numbers, the last element specifies all remaining spaces; if there are more than ColumnCount - 1 numbers, the excess array elements is ignored.

### has Positional[Numeric] @.ColumnWidths

(Optional; not inheritable; PDF 1.6) The desired width of the columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the width of all columns. If the value is an array, it contains numbers, representing the width of each column, in order. If there are fewer than ColumnCount numbers, the last element specifies all remaining widths; if there are more than ColumnCount numbers, the excess array elements is ignored.

