use v6;

use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /XObject - describes an abastract XObject. See also
# PDF::DOM::Type::XObject::Form, PDF::DOM::Type::XObject::Image

class PDF::DOM::Type::XObject
    is PDF::Object::Stream
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    has Array $!BBox is entry(:required);

}
