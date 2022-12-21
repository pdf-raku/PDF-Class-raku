use v6;

class PDF::Annot::Popup {
    use PDF::Annot;
    also is PDF::Annot;

    use PDF::COS::Tie;
    use PDF::COS::Name;

    # use ISO_32000::Table_183-Additional_entries_specific_to_a_pop-up_annotation;
    # also does ISO_32000::Table_183-Additional_entries_specific_to_a_pop-up_annotation;

    has PDF::Annot $.Parent is entry(:indirect); # (Optional; shall be an indirect reference) The parent annotation with which this pop-up annotation shall be associated.
    has Bool $.Open is entry; # Optional) A flag specifying whether the pop-up annotation shall initially be displayed open. Default value: false (closed).

}
