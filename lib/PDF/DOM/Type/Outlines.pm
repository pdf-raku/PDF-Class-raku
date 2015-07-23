use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Outlines - the Outlines dictionary

class PDF::DOM::Type::Outlines
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Int $!Count is tied;
    has Hash $!First is tied;
    has Hash $!Last is tied;

}
