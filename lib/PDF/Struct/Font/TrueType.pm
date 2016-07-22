use v6;
use PDF::Struct::Font::Type1;

# TrueType fonts - /Type /Font /Subtype TrueType
# see [PDF 1.7 Section 5.5.2 TrueType Fonts]
# "A TrueType font dictionary can contain the same entries as a Type 1 font dictionary"
class PDF::Struct::Font::TrueType
    is PDF::Struct::Font::Type1 {
}
