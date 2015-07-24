use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Encoding - a node in the page tree

class PDF::DOM::Type::Encoding
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    has Str $!BaseEncoding is entry;
    has Array $!Differences is entry;

}
