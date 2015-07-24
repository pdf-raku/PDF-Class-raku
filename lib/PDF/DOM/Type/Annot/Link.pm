use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Link
    is PDF::DOM::Type::Annot {

    use PDF::Object::Tie;

    has Hash $!A is entry;
    has $!Dest is entry(:required);
    has Str $!H is entry;
    has Hash $!PA is entry;
    has Array $!QuadPoints is entry;

}
