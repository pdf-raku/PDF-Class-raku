unit role PDF::Field::Choice;

use PDF::Field;
also does PDF::Field::_Instance;

use ISO_32000::Table_231-Additional_entries_specific_to_a_choice_field;
also does ISO_32000::Table_231-Additional_entries_specific_to_a_choice_field;

use ISO_32000_2::Table_234-Additional_entries_specific_to_a_choice_field;
also does ISO_32000_2::Table_234-Additional_entries_specific_to_a_choice_field;

use PDF::COS::Tie;
use PDF::COS::TextString;

has PDF::COS::TextString @.V is entry(:inherit, :array-or-item, :alias<value>);
has PDF::COS::TextString @.DV is entry(:inherit, :array-or-item, :alias<default-value>);

my subset FieldOptions is export(:FieldOptions) where { .[0] ~~ PDF::COS::TextString && (.elems == 1 || .[1] ~~ PDF::COS::TextString) }
proto sub coerce-field-opts($, FieldOptions) is export(:coerce-field-opts) {*}
multi sub coerce-field-opts(Str $a is rw, FieldOptions) {
    PDF::COS.coerce( $a, PDF::COS::TextString)
}
multi sub coerce-field-opts(List $a is rw, FieldOptions) {
    PDF::COS.coerce( $a[$_], PDF::COS::TextString)
        for $a.keys;
}
multi sub coerce-field-opts($_, FieldOptions) {
    warn "unable to coerce {.raku} to field options";
}

has FieldOptions @.Opt is entry(:coerce(&coerce-field-opts));    # (Optional) An array of options to be presented to the user. Each element of the array is either a text string representing one of the available options or an array consisting of two text strings: the option’s export value and the text to be displayed as the name of the option

has UInt $.TI is entry(:alias<top-index>, :default(0));  # Optional) For scrollable list boxes, the top index (the index in the Opt array of the first option visible in the list). Default value: 0.

has UInt @.I is entry(:alias<indices>);   # (Sometimes required, otherwise optional; PDF 1.4) For choice fields that allow multiple selection (MultiSelect flag set), an array of integers, sorted in ascending order, representing the zero-based indices in the Opt array of the currently selected option items. This entry is required when two or more elements in the Opt array have different names but the same export value or when the value of the choice field is an array. In other cases, the entry is permitted but not required. If the items identified by this entry differ from those in the V entry of the field dictionary (see below), the V entry takes precedence.
