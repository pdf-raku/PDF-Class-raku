use v6;

use PDF::DOM::Type::Field;

role PDF::DOM::Type::Field::Button
    does PDF::DOM::Type::Field {

    # [PDF 1.7 TABLE 8.76 Additional entry specific to check box and radio button fields]
    use PDF::DAO::Tie;

    use PDF::DAO::TextString;
    my subset ArrayOfTextStrings of Array where { !.first( !*.isa(PDF::DAO::TextString) ) }
    sub coerce(Array $fields, ArrayOfTextStrings) {
        PDF::DOM::Type::Field.coerce($fields[$_], PDF::DOM::Object::TextString)
	    for $fields.keys
    }

    has ArrayOfTextStrings $.Opt is entry;    #| (Optional; inheritable; PDF 1.4) An array containing one entry for each widget annotation in the Kids array of the radio button or check box field. Each entry is a text string representing the on state of the corresponding widget annotation.

}
