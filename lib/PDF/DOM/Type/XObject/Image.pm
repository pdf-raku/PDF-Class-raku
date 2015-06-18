use v6;

use PDF::DOM::Type::XObject;

class PDF::DOM::Type::XObject::Image
    is PDF::DOM::Type::XObject {

    method Width is rw { self<Width> }
    method Height is rw { self<Height> }
    method ColorSpace is rw { self<ColorSpace> }
    method BitsPerComponent is rw { self<BitsPerComponent> }

}
