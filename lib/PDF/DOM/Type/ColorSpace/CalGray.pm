use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::CalGray
    is PDF::DOM::Type::ColorSpace {

    # see [PDF 1.7 TABLE 4.13 Entries in a CalGray color space dictionary]
    method WhitePoint is rw { self[1]<WhitePoint> }
    method BlackPoint is rw { self[1]<BlackPoint> }
    method Gamma is rw { self[1]<Gamma> }
}
