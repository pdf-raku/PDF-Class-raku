use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Array $!Rect is tied;
    has Str:_ $!Contents is tied;
    has Hash:_ $!P is tied;
    has Str:_ $!NM is tied;
    has Str:_ $!M is tied;
    has Int:_ $!F is tied;
    has Hash:_ $!AP is tied;
    has Str:_ $!AS is tied;
    has Array:_ $!Border is tied;
    has Array:_ $!C is tied;
    has Int:_ $!StructParent is tied;
    has Hash:_ $!OC is tied;

}
