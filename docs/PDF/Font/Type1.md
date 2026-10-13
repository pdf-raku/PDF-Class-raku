[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::COS::Name $.Name

(Required in PDF 1.0; optional otherwise) The name by which this font is referenced in the Font subdictionary of the current resource dictionary. Note: This entry is obsolescent and its use is no longer recommended.

### has PDF::COS::Name $.BaseFont

(Required) The PostScript name of the font. For Type 1 fonts, this is usually the value of the FontName entry in the font program

### has UInt $.FirstChar

(Required except for the standard 14 fonts) The first character code defined in the font’s Widths array

### has UInt $.LastChar

(Required except for the standard 14 fonts) The last character code defined in the font’s Widths array

### has Positional[Numeric] @.Widths

(Required except for the standard 14 fonts; indirect reference preferred) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

### has PDF::FontDescriptor $.FontDescriptor

(Required except for the standard 14 fonts; must be an indirect reference) A font descriptor describing the font’s metrics other than its glyph widths

### has PDF::Font::Type1::EncodingLike $.Encoding

(Optional) A specification of the font’s character encoding if different from its built-in encoding. The value of Encoding is either the name of a predefined encoding (MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding, as described in Appendix D) or an encoding dictionary that specifies differences from the font’s built-in encoding or from a specified predefined encoding

### has PDF::COS::Stream $.ToUnicode

(Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values

