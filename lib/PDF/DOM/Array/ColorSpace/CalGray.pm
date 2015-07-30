use v6;

use PDF::DOM::Array::ColorSpace;

class PDF::DOM::Array::ColorSpace::CalGray
    is PDF::DOM::Array::ColorSpace {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 4.13 Entries in a CalGray color space dictionary]
    has Numeric $.Gramma is entry;              #| (Optional) A number G defining the gamma for the gray (A) component. Gmust be positive and is generally greater than or equal to 1
}
