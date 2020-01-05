use v6;
use PDF::Font;

class PDF::Font::Type0
    is PDF::Font {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::CMap;
    use PDF::Font::CIDFont;

    # use ISO_32000::Table_121-Entries_in_a_Type_0_font_dictionary;
    # also does ISO_32000::Table_121-Entries_in_a_Type_0_font_dictionary;

    has PDF::COS::Name $.BaseFont is entry(:required); # (Required) The PostScript name of the font. In principle, this is an arbitrary name, since there is no font program associated directly with a Type 0 font dictionary.
    subset CMapEnc of PDF::COS where PDF::COS::Name | PDF::CMap;
    has CMapEnc $.Encoding is entry(:required);       # (Required) The name of a predefined CMap, or a stream containing a CMap that maps character codes to font numbers and CIDs.
    has PDF::Font::CIDFont @.DescendantFonts is entry(:required,:len(1));    # (Required) A one-element array specifying the CIDFont dictionary that is the descendant of this Type 0 font.
    has PDF::CMap $.ToUnicode is entry;               # (Optional) A stream containing a CMap file that maps character codes to Unicode values
}
