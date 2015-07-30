use v6;

use PDF::DOM::Array::ColorSpace::CalGray;

class PDF::DOM::Array::ColorSpace::CalRGB
    is PDF::DOM::Array::ColorSpace::CalGray {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 4.14 Entries in a CalRGB color space dictionary]
    has Array $.Matrix is entry;  #| (Optional) An array of nine numbers [ XA YA ZA XB YB ZB XC YC ZC ] specifying the linear interpretation of the decoded A, B, and C components of the color space with respect to the final XYZ representation.

}
