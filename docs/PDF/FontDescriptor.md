[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /FontDescriptor - the FontDescriptor dictionary

### has PDF::COS::Name $.FontName

(Required) The PostScript name of the font.

### has Str $.FontFamily

(Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) A byte string specifying the preferred font family name

### has PDF::FontDescriptor::FontStretchName $.FontStretch

(Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) The font stretch value

### has PDF::FontDescriptor::FontWeightValue $.FontWeight

Optional; PDF 1.5; strongly recommended for Type 3 fonts in Tagged PDF documents) The weight (thickness) component of the fully-qualified font name or font specifier.

### has PDF::FontDescriptor::FontFlags $.Flags

(Required) A collection of flags defining various characteristics of the font

### has Positional[Numeric] @.FontBBox

(Required, except for Type 3 fonts) A rectangle, expressed in the glyph coordinate system, specifying the font bounding box.

### has Numeric $.ItalicAngle

(Required) The angle, expressed in degrees counterclockwise from the vertical, of the dominant vertical strokes of the font.

### has Numeric $.Ascent

(Required, except for Type 3 fonts) The maximum height above the baseline reached by glyphs in this font, excluding the height of glyphs for accented characters.

### has Numeric $.Descent

(Required, except for Type 3 fonts) The maximum depth below the baseline reached by glyphs in this font. The value is a negative number.

### has Numeric $.Leading

(Optional) The spacing between baselines of consecutive lines of text

### has Numeric $.CapHeight

(Required for fonts that have Latin characters, except for Type 3 fonts) The vertical coordinate of the top of flat capital letters, measured from the baseline

### has Numeric $.XHeight

(Optional) The font’s x height: the vertical coordinate of the top of flat nonascending lowercase letters (like the letter x), measured from the baseline, in fonts that have Latin characters

### has Numeric $.StemV

(Required, except for Type 3 fonts) The thickness, measured horizontally, of the dominant vertical stems of glyphs in the font.

### has Numeric $.StemH

(Optional) The thickness, measured vertically, of the dominant horizontal stems of glyphs in the font

### has Numeric $.AvgWidth

(Optional) The average width of glyphs in the font

### has Numeric $.MaxWidth

(Optional) The maximum width of glyphs in the font

### has Numeric $.MissingWidth

(Optional) The width to use for character codes whose widths are not specified in a font dictionary’s Widths array.

### has PDF::FontStream $.FontFile

(Optional) A stream containing a Type 1 font program

### has PDF::FontStream $.FontFile2

(Optional; PDF 1.1) A stream containing a TrueType font program

### has PDF::FontFile $.FontFile3

(Optional; PDF 1.2) A stream containing a font program whose format is specified by the Subtype entry in the stream dictionary. Type1C for Type 1 compact fonts, CIDFontType0C for Type 0 compact CIDFonts, or OpenType for OpenType fonts.

### has Str $.CharSet

Optional; meaningful only in Type 1 fonts; PDF 1.1) A string listing the character names defined in a font subset

