use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has $.font-obj handles <encode decode height stringwidth kern>;

    method Name is rw returns Str { self<Name> }
    method BaseFont is rw returns Str:_ { self<BaseFont> }
    method Encoding is rw { self<Encoding> }

}

