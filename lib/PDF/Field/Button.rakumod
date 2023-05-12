unit role PDF::Field::Button;

use PDF::Field;
also does PDF::Field;

use ISO_32000::Table_227-Additional_entry_specific_to_check_box_and_radio_button_fields;
also does ISO_32000::Table_227-Additional_entry_specific_to_check_box_and_radio_button_fields;

use PDF::COS::Tie;
use PDF::COS::TextString;

has PDF::COS::Name $.V is entry(:inherit);
has PDF::COS::Name $.DV is entry(:inherit, :alias<default-value>);

has PDF::COS::TextString @.Opt is entry(:inherit);    # (Optional; inheritable; PDF 1.4) An array containing one entry for each widget annotation in the Kids array of the radio button or check box field. Each entry is a text string representing the on state of the corresponding widget annotation.
