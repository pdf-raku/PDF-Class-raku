use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has $.font-obj handles <encode decode filter height kern stringwidth>;

    use PDF::Object::Tie;

    has Str $!Name is entry(:required);
    has Str $!BaseFont is entry;
    has $!Encoding is entry(:required);

}

