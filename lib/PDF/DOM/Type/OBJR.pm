use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OBJR - a node in the page tree

class PDF::DOM::Type::OBJR
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Hash:_ $!Pg; method Pg { self.tie(:$!Pg) };
    has $!Obj; method Obj { self.tie(:$!Obj) };

}
