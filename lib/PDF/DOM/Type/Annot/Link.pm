use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Link
    is PDF::DOM::Type::Annot {

    use PDF::Object::Tie;

    has Hash:_ $!A is tied;
    has $!Dest is tied;
    has Str:_ $!H is tied;
    has Hash:_ $!PA is tied;
    has Array:_ $!QuadPoints is tied;

}
