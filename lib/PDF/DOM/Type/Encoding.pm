use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Encoding - a node in the page tree

class PDF::DOM::Type::Encoding
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method BaseEncoding is rw returns Str:_ { self<BaseEncoding> }
    method Differences  is rw returns Array:_ { self<Differences> }

}
