use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::CalRGB
    is PDF::DOM::Type::ColorSpace {

    # see [PDF 1.7 TABLE 4.14 Entries in a CalRGB color space dictionary]
    method WhitePoint is rw { self[1]<WhitePoint> }
    method BlackPoint is rw { self[1]<BlackPoint> }
    method Gamma is rw { self[1]<Gamma> }
    method Matrix is rw { self[1]<Matrix> }

}
