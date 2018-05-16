use v6;

use PDF::COS::Tie::Hash;
role PDF::Font::CIDFont
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Stream;
    use PDF::COS::Name;

    # see [PDF 1.7 TABLE 5.14 Entries in a CIDFont dictionary]
    has PDF::COS::Name $.BaseFont is entry(:required);        #| (Required) The PostScript name of the CIDFont. For Type 0 CIDFonts, this is usually the value of the CIDFontName entry in the CIDFont program. For Type 2 CIDFonts, it is derived the same way as for a simple TrueType font
##    use PDF::CIDSystemInfo; # todo - causing failures in pdf-font-cidfont.t
    has Hash $.CIDSystemInfo is entry(:required);             #| (Required) A dictionary containing entries that define the character collection of the CIDFont.
    #| See [PDF 320000 Table 124 – Additional font descriptor entries for CIDFonts]
    my role CIDFontProps
        does PDF::COS::Tie::Hash {
            has Hash $.Style is entry;              #| (Optional) A dictionary containing entries that describe the style of the glyphs in the font.
            has PDF::COS::Name $.Lang is entry;     #| (Optional; PDF 1.5) A name specifying the language of the font, which may be used for encodings where the language is not implied by the encoding itself. The value shall be one of the codes defined by Internet RFC 3066, Tags for the Identification of Languages or (PDF 1.0) 2-character language codes defined by ISO 639. If this entry is absent, the language shall be considered to be unknown.
            has Hash $.FD is entry;                 #| (Optional) A dictionary whose keys identify a class of glyphs in a CIDFont. Each value shall be a dictionary containing entries that shall override the corresponding values in the main font descriptor dictionary for that class of glyphs.
            has PDF::COS::Stream $.CIDSet is entry; #| (Optional) A stream identifying which CIDs are present in the CIDFont file. If this entry is present, the CIDFont shall contain only a subset of the glyphs in the character collection defined by the CIDSystemInfo dictionary. If it is absent, the only indication of a CIDFont subset shall be the subset tag in the FontName entry (see 9.6.4, "Font Subsets"). The stream’s data shall be organized as a table of bits indexed by CID. The bits shall be stored in bytes with the high-order bit first. Each bit shall correspond to a CID. The most significant bit of the first byte shall correspond to CID 0, the next bit to CID 1, and so on.
    }
    use PDF::FontDescriptor;
    my subset CIDFontDescriptor of PDF::FontDescriptor where CIDFontProps;
    multi sub coerce($_, CIDFontDescriptor) {
        PDF::COS.coerce($_, CIDFontProps);
    }
    has CIDFontDescriptor $.FontDescriptor is entry(:required, :indirect, :&coerce); #| (Required; must be an indirect reference) A font descriptor describing the CIDFont’s default metrics other than its glyph widths
    has UInt $.DW is entry;                                   #| (Optional) The default width for glyphs in the CIDFont
    has @.W is entry;                                         #| (Optional) A description of the widths for the glyphs in the CIDFont. The array’s elements have a variable format that can specify individual widths for consecutive CIDs or one width for a range of CIDs
    has Numeric @.DW2 is entry;                               #| (Optional; applies only to CIDFonts used for vertical writing) An array of two numbers specifying the default metrics for vertical writing
    has Numeric @.W2 is entry;                                #| (Optional; applies only to CIDFonts used for vertical writing) A description of the metrics for vertical writing for the glyphs in the CIDFont
    my subset Identity of PDF::COS::Name where 'Identity';
    my subset StreamOrIdentity where PDF::COS::Stream | Identity;
    has StreamOrIdentity $.CIDToGIDMap is entry;              #| to glyph indices. If the value is a stream, the bytes in the stream contain the mapping from CIDs to glyph indices: the glyph index for a particular CID value c is a 2-byte value stored in bytes 2 × c and 2 × c + 1, where the first byte is the high-order byte. If the value of CIDToGIDMap is a name, it must be Identity, indicating that the mapping between CIDs and glyph indices is the identity mapping

}
