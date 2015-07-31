use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::Lab
    is PDF::DOM::Type::ColorSpace {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 4.15 Entries in a Lab color space dictionary]
    method WhitePoint returns Array is rw { self[1]<WhitePoint> }
    method BlackPoint returns Array:_ is rw { self[1]<BlackPoint> }
    method Range returns Array:_ is rw { self[1]<Range> }

}
