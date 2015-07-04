use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method LW is rw { self<LW> }
    method LC is rw { self<LC> }
    method LJ is rw { self<LJ> }
    method ML is rw { self<ML> }
    method D is rw { self<D> }
    method RI is rw { self<RI> }
    method OP is rw { self<OP> }
    method op is rw { self<op> }
    method OPM is rw { self<OPM> }
    method Font is rw { self<Font> }
    method BG is rw { self<BG> }
    method BG2 is rw { self<BG2> }
    method UCR is rw { self<UCR> }
    method UCR2 is rw { self<UCR2> }
    method TR is rw { self<TR> }
    method TR2 is rw { self<TR2> }
    method HT is rw { self<HT> }
    method FL is rw { self<FL> }
    method SM is rw { self<SM> }
    method SA is rw { self<SA> }
    method BM is rw { self<BM> }
    method SMask is rw { self<SMask> }
    method CA is rw { self<CA> }
    method AIS is rw { self<AIS> }
    method TK is rw { self<TK> }

}
