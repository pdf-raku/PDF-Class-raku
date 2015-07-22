use v6;

use PDF::Object::Stream;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Tiling
    is PDF::Object::Stream
    does PDF::DOM::Type::Pattern {

    has Int $!TilingType; method TilingType { self.tie($!TilingType) };
    has Array $!BBox; method BBox { self.tie($!BBox) };
    has Int $!PaintType; method PaintType { self.tie($!PaintType) };
    has Numeric $!XStep; method XStep { self.tie($!XStep) };
    has Numeric $!YStep; method YStep { self.tie($!YStep) };
    has Hash $!Resources; method Resources { self.tie($!Resources) };
}
