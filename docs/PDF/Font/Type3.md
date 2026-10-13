[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::COS::Name $.Name

(Required in PDF 1.0; optional otherwise) See Table 5.8 on page 413

### has Positional[Numeric] @.FontBBox

(Required) A rectangle expressed in the glyph coordinate system, specifying the font bounding box.

### has Positional[Numeric] @.FontMatrix

(Required) An array of six numbers specifying the font matrix, mapping glyph space to text space

### has Associative[PDF::COS::Stream] %.CharProcs

(Required) A dictionary in which each key is a character name and the value associated with that key is a content stream that constructs and paints the glyph for that character.

### has PDF::Encoding $.Encoding

(Required) An encoding dictionary whose Differences array specifies the complete character encoding for this font

### has UInt $.FirstChar

(Required) The first character code defined in the font’s Widths array

### has UInt $.LastChar

(Required) The last character code defined in the font’s Widths array

### has Positional[Numeric] @.Widths

(Required) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

### has PDF::FontDescriptor $.FontDescriptor

(Required in Tagged PDF documents; must be an indirect reference) A font descriptor describing the font’s default metrics other than its glyph widths

### has PDF::Resources $.Resources

(Optional but strongly recommended; PDF 1.2) A list of the named resources, such as fonts and images, required by the glyph descriptions in this font

### has PDF::COS::Stream $.ToUnicode

(Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values

