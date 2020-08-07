use v6;
use PDF::COS::Tie::Hash;

unit role PDF::Field::AdditionalActions
    does PDF::COS::Tie::Hash;

# use ISO_32000::Table_196-Entries_in_a_form_fields_additional-actions_dictionary;
# also does ISO_32000::Table_196-Entries_in_a_form_fields_additional-actions_dictionary;

use PDF::COS::Tie;
use PDF::Action;

=begin pod

=head1 Description

Table 196 – Entries in a form field’s additional-actions dictionary

=head1 Methods (Entries)
=end pod

#| (Optional; PDF 1.3) A JavaScript action that is performed when the user modifies a character in a text field or combo box or modifies the selection in a scrollable list box. This action may check the added text for validity and reject or modify it.
has PDF::Action $.K is entry(:alias<change>);

#| (Optional; PDF 1.3) A JavaScript action that is performed before the field is formatted to display its value. This action may modify the field’s value before formatting.
has PDF::Action $.F is entry(:alias<format>);

#| (Optional; PDF 1.3) A JavaScript action that is performed when the field’s value is changed. This action may check the new value for validity.
has PDF::Action $.V is entry(:alias<validate>);

#| (Optional; PDF 1.3) A JavaScript action that is performed to recalculate the value of this field when that of another field changes. (The name C stands for “calculate.”) The order in which the document’s fields are recalculated is defined by the CO entry in the interactive form dictionary
has PDF::Action $.C is entry(:alias<calculate>);

