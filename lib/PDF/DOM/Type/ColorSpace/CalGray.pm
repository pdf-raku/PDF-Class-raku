use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::CalGray
    is PDF::DOM::Type::ColorSpace {

    # see [PDF 1.7 TABLE 4.13 Entries in a CalGray color space dictionary]
    method WhitePoint returns Array is rw { self[1]<WhitePoint> }
    method BlackPoint returns Array:_ is rw { self[1]<BlackPoint> }
    method Gamma returns Numeric is rw { self[1]<Gamma> }
}
