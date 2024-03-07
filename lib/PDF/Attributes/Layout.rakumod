unit role PDF::Attributes::Layout;

use PDF::Attributes;
also does PDF::Attributes;

use PDF::COS::Tie;
use PDF::COS::Name;

my subset Auto of PDF::COS::Name where 'Auto';
my subset BorderStyle of PDF::COS::Name where 'None'|'Hidden'|'Dotted'|'Dashed'|'Solid'|'Double'|'Groove'|'Ridge'|'Inset'|'Outset';
my subset NumericOrAuto where Numeric|Auto;
my subset RGB of Numeric where 0.0 <= * <= 1.0;
my subset TextAlign of PDF::COS::Name where 'Start'|'Center'|'End'|'Justify';

use ISO_32000::Table_343-Standard_layout_attributes_common_to_all_standard_structure_types;
also does ISO_32000::Table_343-Standard_layout_attributes_common_to_all_standard_structure_types;

use ISO_32000_2::Table_378-Standard_layout_attributes_common_to_all_standard_structure_types;
also does ISO_32000_2::Table_378-Standard_layout_attributes_common_to_all_standard_structure_types;

my role Common_attributes {

    my subset Placement of PDF::COS::Name where 'Block'|'Inline'|'Before'|'Start'|'End';
    has Placement $.Placement is entry;	# (Optional; not inheritable) The positioning of the element with respect to the enclosing reference area and other content:
            # Block Stacked in the block-progression direction within an enclosing reference area or parent BLSE.
            # Inline Packed in the inline-progression direction within an enclosing BLSE.
            # Before Placed so that the before edge of the element’s allocation rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”) coincides with that of the nearest enclosing reference area. The element may float, if necessary, to achieve the specified placement. The element is treated as a block occupying the full extent of the enclosing reference area in the inline direction. Other content is stacked so as to begin at the after edge of the element’s allocation rectangle.
            # Start Placed so that the start edge of the element’s allocation rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”) coincides with that of the nearest enclosing reference area. The element may float, if necessary, to achieve the specified placement. Other content that would intrude into the element’s allocation rectangle is laid out as a runaround.
            # End Placed so that the end edge of the element’s allocation rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”) coincides with that of the nearest enclosing reference area. The element may float, if necessary, to achieve the specified placement. Other content that would intrude into the element’s allocation rectangle is laid out as a runaround.
            # When applied to an ILSE, any value except Inline causes the element to be treated as a BLSE instead. Default value: Inline.
            # Elements with Placement values of Before, Start, or End is removed from the normal stacking or packing process and allowed to float to the specified edge of the enclosing reference area or parent BLSE. Multiple such floating elements may be positioned adjacent to one another against the specified edge of the reference area or placed serially against the edge, in the order encountered. Complex cases such as floating elements that interfere with each other or do not fit on the same page may be handled differently by different conforming readers. Tagged PDF merely identifies the elements as floating and indicates their desired placement.

    my subset WritingMode of PDF::COS::Name where 'LrTb'|'RlTb'|'TbRl';

    has WritingMode $.WritingMode is entry(:default<LrTb>);	# (Optional; inheritable) The directions of layout progression for packing of ILSEs (inline progression) and stacking of BLSEs (block progression):
            # LrTb Inline progression from left to right; block progression from top to bottom. This is the typical writing mode for Western writing systems.
            # RlTb Inline progression from right to left; block progression from top to bottom. This is the typical writing mode for Arabic and Hebrew writing systems.
            # TbRl Inline progression from top to bottom; block progression from right to left. This is the typical writing mode for Chinese and Japanese writing systems.
            # The specified layout directions applies to the given structure element and all of its descendants to any level of nesting. Default value: LrTb.
            # For elements that produce multiple columns, the writing mode defines the direction of column progression within the reference area: the inline direction determines the stacking direction for columns and the default flow order of text from column to column. For tables, the writing mode controls the layout of rows and columns: table rows (structure type TR) is stacked in the block direction, cells within a row (structure type TD) in the inline direction.
            # The inline-progression direction specified by the writing mode is subject to local override within the text being laid out, as described in Unicode Standard Annex 9, The Bidirectional Algorithm, available from the Unicode Consortium (see the Bibliography).

    has RGB @.BackgroundColor is entry(:len(3));	# (Optional; not inheritable; PDF 1.5) The colour to be used to fill the background of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the element is treated as if it were transparent.

    has RGB @.BorderColor is entry(:len(3));	# (Optional; inheritable; PDF 1.5) The colour of the border drawn on the edges of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value of each edge is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. There are two forms:
            # A single array of three numbers representing the RGB values to apply to all four edges.
            # An array of four arrays, each specifying the RGB values for one edge of the border, in the order of the before, after, start, and end edges. A value of null for any of the edges means that it is not drawn.
    # If this attribute is not specified, the border colour for this element is the current text fill colour in effect at the start of its associated content.

    has BorderStyle @.BorderStyle is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.5) The style of an element’s border. Specifies the stroke pattern of each edge of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). There are two forms:
            # • A name from the list below representing the border style to apply to all four edges.
            # • An array of four entries, each entry specifying the style for one edge of the border in the order of the before, after, start, and end edges. A value of null for any of the edges means that it is not drawn. None No border. Forces the computed value of BorderThickness to be 0. Hidden Same as None, except in terms of border conflict resolution for table elements. Dotted The border is a series of dots. Dashed The border is a series of short line segments. Solid The border is a single line segment. Double The border is two solid lines. The sum of the two lines and the space between them equals the value of BorderThickness. Groove The border looks as though it were carved into the canvas. Ridge The border looks as though it were coming out of the canvas (the opposite of Groove). Inset The border makes the entire box look as though it were embedded in the canvas. Outset The border makes the entire box look as though it were coming out of the canvas (the opposite of Inset). Default value: None All borders is drawn on top of the box’s background. The colour of borders drawn for values of Groove, Ridge, Inset, and Outset depends on the structure element’s BorderColor attribute and the colour of the background over which the border is being drawn.
            # NOTE Conforming HTML applications may interpret Dotted, Dashed, Double, Groove, Ridge, Inset, and Outset to be Solid.

    has Numeric @.BorderThickness is entry(:array-or-item);	# (Optional; inheritable; PDF 1.5) The thickness of the border drawn on the edges of a table cell or any element’s content rectangle (possibly adjusted by the Padding attribute). The value of each edge is a positive number in default user space units representing the border’s thickness (a value of 0 indicates that the border is not drawn). There are two forms:
            # A number representing the border thickness for all four edges.
            # An array of four entries, each entry specifying the thickness for one edge of the border, in the order of the before, after, start, and end edges. A value of null for any of the edges means that it is not drawn.

    has Numeric @.Padding is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.5) Specifies an offset to account for the separation between the element’s content rectangle and the surrounding border (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”). A positive value enlarges the background area; a negative value trims it, possibly allowing the border to overlap the element’s text or graphic.
            # The value is either a single number representing the width of the padding, in default user space units, that applies to all four sides or a 4-element array of numbers representing the padding width for the before, after, start, and end edge, respectively, of the content rectangle. Default value: 0.

    has RGB @.Color is entry(:len(3));	# (Optional; inheritable; PDF 1.5) The colour to be used for drawing text and the default value for the colour of table borders and text decorations. The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the border colour for this element is the current text fill colour in effect at the start of its associated content.
}
also does Common_attributes;

use ISO_32000::Table_344-Additional_standard_layout_attributes_specific_to_block-level_structure_elements;
also does ISO_32000::Table_344-Additional_standard_layout_attributes_specific_to_block-level_structure_elements;

use ISO_32000_2::Table_379-Additional_standard_layout_attributes_specific_to_block-level_structure_elements;
also does ISO_32000_2::Table_379-Additional_standard_layout_attributes_specific_to_block-level_structure_elements;

#| Table 344 – Additional standard layout attributes specific to block-level structure elements
my role BLSE_Attributes {
    has Numeric $.SpaceBefore is entry;	# (Optional; not inheritable) The amount of extra space preceding the before edge of the BLSE, measured in default user space units in the block-progression direction. This value is added to any adjustments induced by the LineHeight attributes of ILSEs within the first line of the BLSE (see “Layout Attributes for ILSEs” in 14.8.5.4, “Layout Attributes”). If the preceding BLSE has a SpaceAfter attribute, the greater of the two attribute values is used. Default value: 0.
            # This attribute is disregarded for the first BLSE placed in a given reference area.

    has Numeric $.SpaceAfter is entry;	# (Optional; not inheritable) The amount of extra space following the after edge of the BLSE, measured in default user space units in the block-progression direction. This value is added to any adjustments induced by the LineHeight attributes of ILSEs within the last line of the BLSE (see 14.8.5.4, “Layout Attributes”). If the following BLSE has a SpaceBefore attribute, the greater of the two attribute values is used. Default value: 0.
            # This attribute is disregarded for the last BLSE placed in a given reference area.

    has Numeric $.StartIndent is entry;	# (Optional; inheritable) The distance from the start edge of the reference area to that of the BLSE, measured in default user space units in the inline-progression direction. This attribute applies only to structure elements with a Placement attribute of Block or Start (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). The attribute is disregarded for elements with other Placement values. Default value: 0.
            # A negative value for this attribute places the start edge of the BLSE outside that of the reference area. The results are implementation- dependent and may not be supported by all conforming products that process Tagged PDF or by particular export formats.
            # If a structure element with a StartIndent attribute is placed adjacent to a floating element with a Placement attribute of Start, the actual value used for the element’s starting indent is its own StartIndent attribute or the inline extent of the adjacent floating element, whichever is greater. This value may be further adjusted by the element’s TextIndent attribute, if any.

    has Numeric $.EndIndent is entry;	# (Optional; inheritable) The distance from the end edge of the BLSE to that of the reference area, measured in default user space units in the inline-progression direction. This attribute applies only to structure elements with a Placement attribute of Block or End (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). The attribute is disregarded for elements with other Placement values. Default value: 0.
            # A negative value for this attribute places the end edge of the BLSE outside that of the reference area. The results are implementation- dependent and may not be supported by all conforming products that process Tagged PDF or by particular export formats.
            # If a structure element with an EndIndent attribute is placed adjacent to a floating element with a Placement attribute of End, the actual value used for the element’s ending indent is its own EndIndent attribute or the inline extent of the adjacent floating element, whichever is greater.

    has Numeric $.TextIndent is entry;	# (Optional; inheritable; applies only to some BLSEs) The additional distance, measured in default user space units in the inline- progression direction, from the start edge of the BLSE, as specified by StartIndent, to that of the first line of text. A negative value indicates a hanging indent. Default value: 0.
            # This attribute applies only to paragraphlike BLSEs and those of structure types Lbl (Label), LBody (List body), TH (Table header), and TD (Table data), provided that they contain content other than nested BLSEs.

    has TextAlign $.TextAlign is entry(:default<Start>);	# (Optional; inheritable; applies only to BLSEs containing text) The alignment, in the inline-progression direction, of text and other content within lines of the BLSE:
            # Start Aligned with the start edge.
            # Center Centered between the start and end edges.
            # End Aligned with the end edge.
            # Justify Aligned with both the start and end edges, with internal spacing within each line expanded, if necessary, to achieve such alignment. The last (or only) line is aligned with the start edge only.
            # Default value: Start.

    has Numeric @.BBox is entry(:len(4));	# (Optional for Annot; required for any figure or table appearing in its entirety on a single page; not inheritable) An array of four numbers in default user space units that shall give the coordinates of the left, bottom, right, and top edges, respectively, of the element’s bounding box (the rectangle that completely encloses its visible content). This attribute applies to any element that lies on a single page and occupies a single rectangle.

    has NumericOrAuto $.Width is entry;	# (Optional; not inheritable; illustrations, tables, table headers, and table cells only; is used for table cells) The width of the element’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”), measured in default user space units in the inline-progression direction. This attribute applies only to elements of structure type Figure, Formula, Form, Table, TH (Table header), or TD (Table data).
            # The name Auto in place of a numeric value indicates that no specific width constraint is to be imposed; the element’s width is determined by the intrinsic width of its content. Default value: Auto.

    has NumericOrAuto $.Height is entry;	# (Optional; not inheritable; illustrations, tables, table headers, and table cells only) The height of the element’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”), measured in default user space units in the block-progression direction. This attribute applies only to elements of structure type Figure, Formula, Form, Table, TH (Table header), or TD (Table data).
            # The name Auto in place of a numeric value indicates that no specific height constraint is to be imposed; the element’s height is determined by the intrinsic height of its content. Default value: Auto.

    my subset BlockAlign of PDF::COS::Name where 'Before'|'Middle'|'After'|'Justify';
    has BlockAlign $.BlockAlign is entry(:default<Before>);	# (Optional; inheritable; table cells only) The alignment, in the block- progression direction, of content within the table cell:
            # Before Before edge of the first child’s allocation rectangle aligned with that of the table cell’s content rectangle.
            # Middle Children centered within the table cell. The distance between the before edge of the first child’s allocation rectangle and that of the table cell’s content rectangle is the same as the distance between the after edge of the last child’s allocation rectangle and that of the table cell’s content rectangle.
            # After After edge of the last child’s allocation rectangle aligned with that of the table cell’s content rectangle.
            # Justify Children aligned with both the before and after edges of the table cell’s content rectangle. The first child is placed as described for Before and the last child as described for After, with equal spacing between the children. If there is only one child, it is aligned with the before edge only, as for Before.
            # This attribute applies only to elements of structure type TH (Table header) or TD (Table data) and shall control the placement of all BLSEs that are children of the given element. The table cell’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”) shall become the reference area for all of its descendants. Default value: Before.

    my subset InlineAlign of PDF::COS::Name where 'Start'|'Center'|'End';
    has InlineAlign $.InlineAlign is entry(:default<Start>);	# (Optional; inheritable; table cells only) The alignment, in the inline- progression direction, of content within the table cell:
            # Start Start edge of each child’s allocation rectangle aligned with that of the table cell’s content rectangle.
            # Center Each child centered within the table cell. The distance between the start edges of the child’s allocation rectangle and the table cell’s content rectangle is the same as the distance between their end edges.
            # End End edge of each child’s allocation rectangle aligned with that of the table cell’s content rectangle.
            # This attribute applies only to elements of structure type TH (Table header) or TD (Table data) and controls the placement of all BLSEs that are children of the given element. The table cell’s content rectangle (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”) shall become the reference area for all of its descendants. Default value: Start.

    has BorderStyle @.TBorderStyle is entry(:array-or-item);	# (Optional; inheritable; PDF 1.5) The style of the border drawn on each edge of a table cell. Allowed values is the same as those specified for BorderStyle (see Table 343). If both TBorderStyle and BorderStyle apply to a given table cell, BorderStyle shall supersede TBorderStyle. Default value: None.

    has Int @.TPadding is entry(:array-or-item, :default(0));	# (Optional; inheritable; PDF 1.5) Specifies an offset to account for the separation between the table cell’s content rectangle and the surrounding border (see “Content and Allocation Rectangles” in 14.8.5.4, “Layout Attributes”). If both TPadding and Padding apply to a given table cell, Padding shall supersede TPadding. A positive value shall enlarge the background area; a negative value shall trim it, and the border may overlap the element’s text or graphic. The value is either a single number representing the width of the padding, in default user space units, that applies to all four edges of the table cell or a 4-entry array representing the padding width for the before edge, after edge, start edge, and end edge, respectively, of the content rectangle. Default value: 0.
}
also does BLSE_Attributes;

use ISO_32000::Table_345-Standard_layout_attributes_specific_to_inline-level_structure_elements;
also does ISO_32000::Table_345-Standard_layout_attributes_specific_to_inline-level_structure_elements;

use ISO_32000_2::Table_380-Standard_layout_attributes_specific_to_inline-level_structure_elements;
also does ISO_32000_2::Table_380-Standard_layout_attributes_specific_to_inline-level_structure_elements;

#| Table 345 – Standard layout attributes specific to inline-level structure elements
my role ILSE_Attributes {

    has Numeric $.BaselineShift is entry;	# (Optional; not inheritable) The distance, in default user space units, by which the element’s baseline is shifted relative to that of its parent element. The shift direction is the opposite of the block-progression direction specified by the prevailing WritingMode attribute (see “General Layout Attributes” in 14.8.5.4, “Layout Attributes”). Thus, positive values shall shift the baseline toward the before edge and negative values toward the after edge of the reference area (upward and downward, respectively, in Western writing systems). Default value: 0.
            # The shifted element may be a superscript, a subscript, or an inline graphic. The shift applies to the element, its content, and all of its descendants. Any further baseline shift applied to a child of this element is measured relative to the shifted baseline of this (parent) element.

    my subset LineHeightName of PDF::COS::Name where 'Normal'|'Auto';
    my subset LineHeight where Numeric|LineHeightName;
    has LineHeight $.LineHeight is entry(:default<Normal>);	# (Optional; inheritable) The element’s preferred height, measured in default user space units in the block-progression direction. The height of a line is determined by the largest LineHeight value for any complete or partial ILSE that it contains.
            # The name Normal or Auto in place of a numeric value indicates that no specific height constraint is to be imposed. The element’s height is set to a reasonable value based on the content’s font size:
            # Normal Adjust the line height to include any nonzero value specified for BaselineShift.
            # Auto Adjustment for the value of BaselineShift is not made.
            # Default value: Normal.
            # This attribute applies to all ILSEs (including implicit ones) that are children of this element or of its nested ILSEs, if any. It does not apply to nested BLSEs.
            # When translating to a specific export format, the values Normal and Auto, if specified, is used directly if they are available in the target format. The meaning of the term “reasonable value” is left to the conforming reader to determine. It is approximately 1.2 times the font size, but this value can vary depending on the export format.
            # NOTE 1 In the absence of a numeric value for LineHeight or an explicit value for the font size, a reasonable method of calculating the line height from the information in a Tagged PDF file is to find the difference between the associated font’s Ascent and Descent values (see 9.8, “Font Descriptors”), map it from glyph space to default user space (see 9.4.4, “Text Space Details”), and use the maximum resulting value for any character in the line.

    my subset TextPosition of PDF::COS::Name where 'Sup'|'Sub'|'Normal';
    has TextPosition $.TextPosition is entry;           # Optional; inheritable; PDF 2.0) The position of the element relative the immediately surrounding content.

    has RGB @.TextDecorationColor is entry(:len(3));	# (Optional; inheritable; PDF 1.5) The colour to be used for drawing text decorations. The value is an array of three numbers in the range 0.0 to 1.0, representing the red, green, and blue values, respectively, of an RGB colour space. If this attribute is not specified, the border colour for this element is the current fill colour in effect at the start of its associated content.

    has Numeric $.TextDecorationThickness is entry;	# (Optional; inheritable; PDF 1.5) The thickness of each line drawn as part of the text decoration. The value is a non-negative number in default user space units representing the thickness (0 is interpreted as the thinnest possible line). If this attribute is not specified, it is derived from the current stroke thickness in effect at the start of the element’s associated content, transformed into default user space units.

    my subset TextDecorationType of PDF::COS::Name where 'None'|'Underline'|'Overline'|'LineThrough';
    has TextDecorationType $.TextDecorationType is entry(:default<None>);	# (Optional; not inheritable) The text decoration, if any, to be applied to the element’s text.
            # None No text decoration
            # Underline A line below the text
            # Overline A line above the text
            # LineThrough A line through the middle of the text
            # Default value: None.
            # This attribute applies to all text content items that are children of this element or of its nested ILSEs, if any. The attribute does not apply to nested BLSEs or to content items other than text.
            # The colour, position, and thickness of the decoration is uniform across all children, regardless of changes in colour, font size, or other variations in the content’s text characteristics.

    my subset RubyAlign of PDF::COS::Name where TextAlign|'Distribute';
    has RubyAlign $.RubyAlign is entry(:default<Distribute>);	# (Optional; inheritable; PDF 1.5) The justification of the lines within a ruby assembly:
            # Start The content is aligned on the start edge in the inline-progression direction.
            # Center The content is centered in the inline-progression direction.
            # End The content is aligned on the end edge in the inline-progression direction.
            # Justify The content is expanded to fill the available width in the inline-progression direction.
            # Distribute The content is expanded to fill the available width in the inline-progression direction. However, space is also inserted at the start edge and end edge of the text. The spacing is distributed using a 1:2:1 (start:infix:end) ratio. It is changed to a 0:1:1 ratio if the ruby appears at the start of a text line or to a 1:1:0 ratio if the ruby appears at the end of the text line.
            # Default value: Distribute.
            # This attribute may be specified on the RB and RT elements. When a ruby is formatted, the attribute is applied to the shorter line of these two elements. (If the RT element has a shorter width than the RB element, the RT element is aligned as specified in its RubyAlign attribute.)

    my subset RubyPosition of PDF::COS::Name where 'Before'|'After'|'Warichu'|'Inline';
    has RubyPosition $.RubyPosition is entry(:default<Before>);	# (Optional; inheritable; PDF 1.5) The placement of the RT structure element relative to the RB element in a ruby assembly:
            # Before The RT content is aligned along the before edge of the element.
            # After The RT content is aligned along the after edge of the element.
            # Warichu The RT and associated RP elements is formatted as a warichu, following the RB element.
            # Inline The RT and associated RP elements is formatted as a parenthesis comment, following the RB element.
            # Default value: Before.

    has NumericOrAuto $.GlyphOrientationVertical is entry;	# (Optional; inheritable; PDF 1.5) Specifies the orientation of glyphs when the inline-progression direction is top to bottom or bottom to top.
            # This attribute may take one of the following values:
            # angle A number representing the clockwise rotation in degrees of the top of the glyphs relative to the top of the reference area. Shall be a multiple of 90 degrees between -180 and +360.
            # AutoSpecifies a default orientation for text, depending on whether it is fullwidth (as wide as it is high). Fullwidth Latin and fullwidth ideographic text (excluding ideographic punctuation) is set with an angle of 0. Ideographic punctuation and other ideographic characters having alternate horizontal and vertical forms uses the vertical form of the glyph. Non-fullwidth text is set with an angle of 90.
            # Default value: Auto.
            # NOTE 2 This attribute is used most commonly to differentiate between the preferred orientation of alphabetic (non- ideographic) text in vertically written Japanese documents (Auto or 90) and the orientation of the ideographic characters and/or alphabetic (non- ideographic) text in western signage and advertising (90). This attribute shall affect both the alignment and width of the glyphs. If a glyph is perpendicular to the vertical baseline, its horizontal alignment point is aligned with the alignment baseline for the script to which the glyph belongs. The width of the glyph area is determined from the horizontal width font characteristic for the glyph.
}
also does ILSE_Attributes;

use ISO_32000::Table_346-Standard_column_attributes;
also does ISO_32000::Table_346-Standard_column_attributes;

use ISO_32000_2::Table_381-Standard_layout_attributes_specific_to_standard_column_attributes;
also does ISO_32000_2::Table_381-Standard_layout_attributes_specific_to_standard_column_attributes;

my role Column_Attributes {

    has Int $.ColumnCount is entry(:default(1));	# (Optional; not inheritable; PDF 1.6) The number of columns in the content of the grouping element. Default value: 1.

    has Numeric @.ColumnGap is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.6) The desired space between adjacent columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the space between all columns. If the value is an array, it contains numbers, the first element specifying the space between the first and second columns, the second specifying the space between the second and third columns, and so on. If there are fewer than ColumnCount - 1 numbers, the last element specifies all remaining spaces; if there are more than ColumnCount - 1 numbers, the excess array elements is ignored.

    has Numeric @.ColumnWidths is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.6) The desired width of the columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the width of all columns. If the value is an array, it contains numbers, representing the width of each column, in order. If there are fewer than ColumnCount numbers, the last element specifies all remaining widths; if there are more than ColumnCount numbers, the excess array elements is ignored.
}
also does Column_Attributes;
