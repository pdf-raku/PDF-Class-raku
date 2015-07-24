use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Array $!Rect is entry(:required);
    has Str $!Contents is entry;
    has Hash $!P is entry;
    has Str $!NM is entry;
    has Str $!M is entry;
    has Int $!F is entry;
    has Hash $!AP is entry;
    has Str $!AS is entry;
    has Array $!Border is entry;
    has Array $!C is entry;
    has Int $!StructParent is entry;
    has Hash $!OC is entry;

}
