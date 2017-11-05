use v6;
use PDF::Font;

class PDF::Font::Type1
    is PDF::Font {

    use PDF::DAO::Tie;
    use PDF::DAO::Dict;
    use PDF::DAO::Name;
    use PDF::DAO::Stream;

    # see [PDF 1.7 TABLE 5.8 Entries in a Type 1 font dictionary]
    has PDF::DAO::Name $.Name is entry;                 #| (Required in PDF 1.0; optional otherwise) The name by which this font is referenced in the Font subdictionary of the current resource dictionary.
                                                        #| Note: This entry is obsolescent and its use is no longer recommended.
    has PDF::DAO::Name $.BaseFont is entry(:required);  #| (Required) The PostScript name of the font. For Type 1 fonts, this is usually the value of the FontName entry in the font program

    has UInt $.FirstChar is entry;                      #| (Required except for the standard 14 fonts) The first character code defined in the font’s Widths array

    has UInt $.LastChar is entry;                       #| (Required except for the standard 14 fonts) The last character code defined in the font’s Widths array

    ## has Numeric @.Widths; # causing errors in t/pdf-resources.t
    has @.Widths is entry;                      #| (Required except for the standard 14 fonts; indirect reference preferred) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

    use PDF::FontDescriptor;
    has PDF::FontDescriptor $.FontDescriptor is entry(:indirect);      #| (Required except for the standard 14 fonts; must be an indirect reference) A font descriptor describing the font’s metrics other than its glyph widths

    use PDF::Encoding;
    my subset NameOrEncoding where PDF::DAO::Name | PDF::Encoding;
    has NameOrEncoding $.Encoding is entry;             #| (Optional) A specification of the font’s character encoding if different from its built-in encoding. The value of Encoding is either the name of a predefined encoding (MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding, as described in Appendix D) or an encoding dictionary that specifies differences from the font’s built-in encoding or from a specified predefined encoding

    has PDF::DAO::Stream $.ToUnicode is entry;                 #| (Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values

    method make-font-obj {

        use Font::AFM;
        use PDF::Content::Util::CoreFont :Encoded, :core-font-name;
        use PDF::Content::Font::Enc::Type1;
        use PDF::Content::Font::Enc::CMap;

        # todo: handle Widths array

        my $base-font = core-font-name(self.BaseFont)
            // 'courier';

        with self.ToUnicode -> $cmap {
            my $encoder = PDF::Content::Font::Enc::CMap.new: :$cmap;
            (Font::AFM.metrics-class( $base-font )
             but Encoded[$encoder]).new;
        }
        else {
            my $enc = do given self.Encoding {
                when 'WinAnsiEncoding' { 'win' }
                when 'MacRomanEncoding' { 'mac' }
                default {
                    warn "ignoring font encoding: $_" if .defined;
                    when $base-font ~~ /^symbol/ { 'sym' }
                    when $base-font ~~ /^zapfdingbats/ { 'zapf' }
                    default { 'std' }
                }
            }
            PDF::Content::Util::CoreFont::load-font($base-font, :$enc);
        }

    }
}
