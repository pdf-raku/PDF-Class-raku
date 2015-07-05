use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method LW is rw returns Numeric:_ { self<LW> }
    method LC is rw returns Int:_ { self<LC> }
    method LJ is rw returns Int:_ { self<LJ> }
    method ML is rw returns Numeric:_ { self<ML> }
    method D is rw returns Array:_ { self<D> }
    method RI is rw returns Str:_ { self<RI> }
    method OP is rw returns Bool:_ { self<OP> }
    method op is rw returns Bool:_ { self<op> }
    method OPM is rw returns Int:_ { self<OPM> }
    method Font is rw returns Array:_ { self<Font> }
    method BG is rw { self<BG> }
    method BG2 is rw { self<BG2> }
    method UCR is rw { self<UCR> }
    method UCR2 is rw { self<UCR2> }
    method TR is rw { self<TR> }
    method TR2 is rw { self<TR2> }
    method HT is rw { self<HT> }
    method FL is rw returns Numeric:_ { self<FL> }
    method SM is rw returns Numeric:_ { self<SM> }
    method SA is rw returns Bool:_ { self<SA> }
    method BM is rw { self<BM> }
    method SMask is rw { self<SMask> }
    method CA is rw returns Numeric:_ { self<CA> }
    method ca is rw returns Numeric:_ { self<ca> }
    method AIS is rw returns Bool:_ { self<AIS> }
    method TK is rw returns Bool:_ { self<TK> }

}
