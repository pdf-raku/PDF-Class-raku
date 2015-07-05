use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Link
    is PDF::DOM::Type::Annot {

    method A is rw returns Hash:_ { self<A> }
    method Dest is rw { self<Dest> }
    method H is rw returns Str:_ { self<H> }
    method PA is rw returns Hash:_ { self<PA> }
    method QuadPoints is rw returns Array:_ { self<QuadPoints> }

}
