use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Link
    is PDF::DOM::Type::Annot {

    has Hash:_ $!A; method A { self.tie($!A) };
    has $!Dest; method Dest { self.tie($!Dest) };
    has Str:_ $!H; method H { self.tie($!H) };
    has Hash:_ $!PA; method PA { self.tie($!PA) };
    has Array:_ $!QuadPoints; method QuadPoints { self.tie($!QuadPoints) };

}
