#| Postscript XObjects /Type XObject /Subtype PS
#| See [PDF 32000 Section 8.8.2 PostScript XObjects]
unit class PDF::XObject::PS;

use PDF::XObject;
use PDF::Content::XObject;
also is PDF::XObject;
also does PDF::Content::XObject['PS'];

use ISO_32000::Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary;
also does ISO_32000::Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary;

# Deprecated in PDF 2.0

use PDF::COS::Tie;
use PDF::COS::Stream;

has PDF::COS::Stream $.Level1 is entry; # (Optional) A stream whose contents are to be used in place of the PostScript XObject’s stream when the target PostScript interpreter is known to support only LanguageLevel 1.

=begin pod

=comment adapted from [ISO-32000 Section 8.8.2 PostScript XObjects]

Beginning with PDF 1.1, a content stream may include PostScript language fragments. These fragments may
be used only when printing to a PostScript output device; they have no effect either when viewing the
document on-screen or when printing it to a non-PostScript device. In addition, conforming readers do
do not interpret the PostScript fragments. Hence, this capability should be used with extreme caution and only
if there is no other way to achieve the same result. Inappropriate use of PostScript XObjects can cause PDF
files to print incorrectly.

=end pod
