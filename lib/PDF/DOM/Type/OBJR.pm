use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OBJR - a node in the page tree

class PDF::DOM::Type::OBJR
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Pg is rw returns Hash:_ { self<Pg> }
    method Obj  is rw { self<Obj> }

}
