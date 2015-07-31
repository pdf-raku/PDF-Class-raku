use v6;

use PDF::DOM::Array::ColorSpace;

class PDF::DOM::Array::ColorSpace::Lab
    is PDF::DOM::Array::ColorSpace {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 4.15 Entries in a Lab color space dictionary]
    method WhitePoint is rw { self[1]<WhitePoint> }
    method BlackPoint is rw { self[1]<BlackPoint> }
    method Range is rw { self[1]<Range> }

}
