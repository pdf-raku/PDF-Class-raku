use v6;

use PDF::DAO::Stream;
use PDF::DOM::Type;

# /Type /XObject - describes an abastract XObject. See also
# PDF::DOM::Type::XObject::Form, PDF::DOM::Type::XObject::Image

class PDF::DOM::Type::XObject
    is PDF::DAO::Stream
    does PDF::DOM::Type {

}
