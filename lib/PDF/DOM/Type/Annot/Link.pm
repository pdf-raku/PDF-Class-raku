use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Link
    is PDF::DOM::Type::Annot {

    method A is rw { self<A> }
    method Dest is rw { self<Dest> }
    method H is rw { self<H> }
    method PA is rw { self<PA> }
    method QuadPoints is rw { self<QuadPoints> }

}
