use v6;

use PDF::Object::Dict;
use PDF::DOM;

# /Type /Font - Describes a font

class PDF::DOM::Font
    is PDF::Object::Dict
    does PDF::DOM {

    method Name is rw { self<Name> }
    method BaseFont is rw { self<BaseFont> }
    method Encoding is rw { self<Encoding> }

}

