use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    use PDF::Object::Tie;

    has Bool $!Open is entry;
    has Str $!Name is entry;
    has Str $!State is entry;
    has Str $!StateModel is entry;

}
