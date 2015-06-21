use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Name is rw { self<Name> }
    method BaseFont is rw { self<BaseFont> }
    method Encoding is rw { self<Encoding> }

}
