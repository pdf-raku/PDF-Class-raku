use v6;

use PDF::DOM::Array::ColorSpace;

class PDF::DOM::Array::ColorSpace::Lab
    is PDF::DOM::Array::ColorSpace {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 4.15 Entries in a Lab color space dictionary]
    has Array $!Range is entry;  #| (Optional) An array of four numbers [ amin amax bmin bmax ] specifying the range of valid values for the a* and b* (B and C) components of the color space
}
