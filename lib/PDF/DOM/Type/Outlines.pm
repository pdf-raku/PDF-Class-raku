use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Outlines - the Outlines dictionary

class PDF::DOM::Type::Outlines
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Count is rw returns Int { self<Count> }
    method First is rw returns Hash { self<First> }
    method Last  is rw returns Hash { self<Last> }

}
