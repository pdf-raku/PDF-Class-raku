use v6;

use PDF::Struct::Field;

role PDF::Struct::Field::Button
    does PDF::Struct::Field {

    # [PDF 1.7 TABLE 8.76 Additional entry specific to check box and radio button fields]
    use PDF::DAO::Tie;
    use PDF::DAO::TextString;


    has PDF::DAO::Name $.V is entry(:inherit);
    has PDF::DAO::Name $.DV is entry(:inherit);

    has PDF::DAO::TextString @.Opt is entry;    #| (Optional; inheritable; PDF 1.4) An array containing one entry for each widget annotation in the Kids array of the radio button or check box field. Each entry is a text string representing the on state of the corresponding widget annotation.

}
