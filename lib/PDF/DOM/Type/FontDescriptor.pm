use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    # see [PDF 1.7 TABLE 5.19 Entries common to all font descriptors]
    has PDF::Object::Name $.FontName is entry(:required); #| (Required) The PostScript name of the font.
    has Str $.FontFamily is entry;                        #| (Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) A byte string specifying the preferred font family name
    subset FontStretchName of PDF::Object::Name where 'ExtraCondensed'|'Condensed'|'SemiCondensed'|'Normal'|'SemiExpanded'|'Expanded'|'ExtraExpanded'|'UltraExpanded';
    has FontStretchName $.FontStretch is entry;           #| (Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) The font stretch value
    subset FontWeightValue of Int where 100|200|300|400|500|600|700|800|900;
    has FontWeightValue $.FontWeight is entry;            #| Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) The weight (thickness) component of the fully-qualified font name or font specifier.
    subset FontFlags of Int where 0 ..^ (2 +< 7);
    has FontFlags $.Flags is entry;                       #| (Required) A collection of flags defining various characteristics of the font
    has Array $.FontBBox is entry;                        #| (Required, except for Type 3 fonts) A rectangle, expressed in the glyph coordinate system, specifying the font bounding box.
    has Numeric $.ItalicAngle is entry;                   #| (Required) The angle, expressed in degrees counterclockwise from the vertical, of the dominant vertical strokes of the font. (
    has Numeric $.Ascent is entry;                        #| (Required, except for Type 3 fonts) The maximum height above the baseline reached by glyphs in this font, excluding the height of glyphs for accented characters.
    has Numeric $.Descent is entry;                       #| (Required, except for Type 3 fonts) The maximum depth below the baseline reached by glyphs in this font. The value is a negative number.
    has Numeric $.Leading is entry;                       #| (Optional) The spacing between baselines of consecutive lines of text
    has Numeric $.CapHeight is entry;                     #| (Required for fonts that have Latin characters, except for Type 3 fonts) The vertical coordinate of the top of flat capital letters, measured from the baseline
    has Numeric $.XHeight is entry;                       #| (Optional) The font’s x height: the vertical coordinate of the top of flat nonascending lowercase letters (like the letter x), measured from the baseline, in fonts that have Latin characters
    has Numeric $.StemV is entry;                         #| (Required, except for Type 3 fonts) The thickness, measured horizontally, of the dominant vertical stems of glyphs in the font.
    has Numeric $.StemH is entry;                         #| (Optional) The thickness, measured vertically, of the dominant horizontal stems of glyphs in the font
    has Numeric $.AvgWidth is entry;                      #| (Optional) The average width of glyphs in the font
    has Numeric $.MaxWidth is entry;                      #| (Optional) The maximum width of glyphs in the font
    has Numeric $.MissingWidth is entry;                  #| (Optional) The width to use for character codes whose widths are not specified in a font dictionary’s Widths array.
    has PDF::Object::Stream $.FontFile is entry;          #| (Optional) A stream containing a Type 1 font program
    has PDF::Object::Stream $.FontFile2 is entry;         #| (Optional; PDF 1.1) A stream containing a TrueType font program
    has PDF::Object::Stream $.FontFile3 is entry;         #| (Optional; PDF 1.2) A stream containing a font program whose format is specified by the Subtype entry in the stream dictionary
    has Str $.CharSet is entry;                           #| Optional; meaningful only in Type 1 fonts; PDF 1.1) A string listing the character names defined in a font subset


}
