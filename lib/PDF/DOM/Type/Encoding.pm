use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Encoding - a node in the page tree

class PDF::DOM::Type::Encoding
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Str:_ $!BaseEncoding; method BaseEncoding { self.tie(:$!BaseEncoding) };
    has Array:_ $!Differences; method Differences { self.tie(:$!Differences) };

}
