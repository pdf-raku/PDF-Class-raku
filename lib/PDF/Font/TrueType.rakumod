#| TrueType fonts - /Type /Font /Subtype TrueType
#| see [PDF 32000 Section 9.6.3 TrueType Fonts]
# "A TrueType font dictionary can contain the same entries as a Type 1 font dictionary"
unit class PDF::Font::TrueType;

use PDF::Font::Type1;
also is PDF::Font::Type1;

