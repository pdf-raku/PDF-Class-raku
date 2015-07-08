use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Outlines - the Outlines dictionary

class PDF::DOM::Type::Outlines
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Int $!Count; method Count { self.tie($!Count) };
    has Hash $!First; method First { self.tie($!First) };
    has Hash $!Last; method Last { self.tie($!Last) };

}
