use v6;

use PDF::Action;
use PDF::COS::Dict;

#| /Action Subtype - GoTo

class PDF::Action::JavaScript
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_217-Additional_entries_specific_to_a_JavaScript_action;
    # also does ISO_32000::Table_217-Additional_entries_specific_to_a_JavaScript_action;

    use PDF::COS::Tie;
    use PDF::COS::Stream;
    use PDF::COS::TextString;
    use PDF::Class::Defs :TextOrStream;

    has TextOrStream $.JS is entry(:required, :coerce(&coerce-text-or-stream), :alias<java-script>); # (Required) A text string or text stream containing the JavaScript script to be executed. PDFDocEncoding or Unicode encoding (the latter identified by the Unicode prefix U+ FEFF) shall be used to encode the contents of thestring or stream.

}
