use v6;
use PDF::Font;

class PDF::Font::Type1
    is PDF::Font {

    use PDF::COS::Tie;
    use PDF::COS::Dict;
    use PDF::COS::Name;
    use PDF::COS::Stream;

    use PDF::Encoding;
    use PDF::FontDescriptor;

    # use ISO_32000::Table_111-Entries_in_a_Type_1_font_dictionary;
    # also does ISO_32000::Table_111-Entries_in_a_Type_1_font_dictionary;

    has PDF::COS::Name $.Name is entry;                 # (Required in PDF 1.0; optional otherwise) The name by which this font is referenced in the Font subdictionary of the current resource dictionary.
                                                        # Note: This entry is obsolescent and its use is no longer recommended.
    has PDF::COS::Name $.BaseFont is entry(:required);  # (Required) The PostScript name of the font. For Type 1 fonts, this is usually the value of the FontName entry in the font program

    has UInt $.FirstChar is entry;                      # (Required except for the standard 14 fonts) The first character code defined in the font’s Widths array

    has UInt $.LastChar is entry;                       # (Required except for the standard 14 fonts) The last character code defined in the font’s Widths array

    has Numeric @.Widths is entry(:indirect);           # (Required except for the standard 14 fonts; indirect reference preferred) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

    has PDF::FontDescriptor $.FontDescriptor is entry(:indirect);      # (Required except for the standard 14 fonts; must be an indirect reference) A font descriptor describing the font’s metrics other than its glyph widths

    my subset EncodingLike where PDF::COS::Name | PDF::Encoding;
    multi sub coerce-enc(Hash $dict, EncodingLike) {
        PDF::Encode.COERCE($dict);
    }
    has EncodingLike $.Encoding is entry(:coerce(&coerce-enc));     # (Optional) A specification of the font’s character encoding if different from its built-in encoding. The value of Encoding is either the name of a predefined encoding (MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding, as described in Appendix D) or an encoding dictionary that specifies differences from the font’s built-in encoding or from a specified predefined encoding

    has PDF::COS::Stream $.ToUnicode is entry;          # (Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values

}
