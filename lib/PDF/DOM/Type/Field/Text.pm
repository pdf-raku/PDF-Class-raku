use v6;

use PDF::DOM::Type::Field;

role PDF::DOM::Type::Field::Text
    does PDF::DOM::Type::Field {

    use PDF::Object::Tie;

    # [PDF 1.7 TABLE 8.78 Additional entry specific to a text field]

    has UInt $.MaxLen is entry; #| (Optional; inheritable) The maximum length of the field’s text, in characters.
}
