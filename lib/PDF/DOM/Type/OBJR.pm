use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OBJR - a node in the page tree

class PDF::DOM::Type::OBJR
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    has Hash:_ $!Pg is tied;
    has $!Obj is tied;

}
