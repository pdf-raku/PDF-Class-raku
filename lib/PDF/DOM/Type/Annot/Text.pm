use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    use PDF::Object::Tie;

    has Bool:_ $!Open is tied;
    has Str:_ $!Name is tied;
    has Str:_ $!State is tied;
    has Str:_ $!StateModel is tied;

}
