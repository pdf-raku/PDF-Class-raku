use v6;

use PDF::XObject;
use PDF::Content::XObject;

#| Postscript XObjects /Type XObject /Subtype PS
#| See [PDF 32000 Section 8.8.2 PostScript XObjects]
class PDF::XObject::PS
    is PDF::XObject
    does PDF::Content::XObject['PS'] {

    use ISO_32000::Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary;
    also does ISO_32000::Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary;

    use PDF::COS::Tie;
    use PDF::COS::Stream;

    has PDF::COS::Stream $.Level1 is entry; # (Optional) A stream whose contents are to be used in place of the PostScript XObject’s stream when the target PostScript interpreter is known to support only LanguageLevel 1.

}
