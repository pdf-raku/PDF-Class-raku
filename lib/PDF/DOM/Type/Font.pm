use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has $.font-obj handles <encode decode filter height kern stringwidth>;

    use PDF::Object::Tie;
    use PDF::Object::Name;
    use PDF::Object::Stream;

    #| See 
    has PDF::Object::Name $!Name is entry(:required);
    has PDF::Object::Name $!BaseFont is entry;
    subset NameOrDict of Any where PDF::Object::Name | PDF::Object::Dict;
    has NameOrDict $!Encoding is entry;

}

