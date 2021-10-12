use v6;

use PDF::Action;
use PDF::COS::Dict;

#| /Action Subtype - URI

class PDF::Action::SubmitForm
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_236-Additional_entries_specific_to_a_submit-form_action;
    # also does ISO_32000::Table_236-Additional_entries_specific_to_a_submit-form_action;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;
    use PDF::Filespec :FileRef, :&to-file;
    use PDF::Field :&coerce-field;

=begin pod

=head1 Description

Table 236 – Additional entries specific to a submit-form action

=head1 Methods (Entries)
=end pod

    #| (Required) A URL file specification giving the uniform resource locator (URL) of the script at the Web server that will process the submission.
    has FileRef $.F is entry(:required, :coerce(&to-file));

    #| (Optional) An array identifying which fields to include in the submission or which to exclude, depending on the setting of the Include/Exclude flag in the Flags entry. Each element of the array is either an indirect reference to a field dictionary or (PDF 1.3) a text string representing the fully qualified name of a field. Elements of both kinds may be mixed in the same array.
    my subset FieldRef where PDF::Field|PDF::COS::TextString;
    multi sub coerce-field-ref(Hash $fld, FieldRef) { coerce-field($fld, PDF::Field) }
    multi sub coerce-field-ref(Str $value is rw, FieldRef) { $value = PDF::COS::TextString.COERCE($value) }
    multi sub coerce-field-ref($_, $) { warn "unable to coerce to field reference: {.raku}"; }
    has FieldRef @.Fields is entry(:coerce(&coerce-field));
    =para If this entry is omitted, the Include/Exclude flag is ignored, and all fields in the document’s interactive form is submitted except those whose NoExport flag is set. Fields with no values may also be excluded, as dictated by the value of the IncludeNoValueFields flag.

    #| (Optional; inheritable) A set of flags specifying various characteristics of the action (see Table 237). Default value: 0.
    has UInt $.Flags is entry(:default(0));

}
