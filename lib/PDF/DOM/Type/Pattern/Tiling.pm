use v6;

use PDF::Object::Stream;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Tiling
    is PDF::Object::Stream
    does PDF::DOM::Type::Pattern {

    use PDF::Object::Tie;

    has Int $!TilingType is tied;
    has Array $!BBox is tied;
    has Int $!PaintType is tied;
    has Numeric $!XStep is tied;
    has Numeric $!YStep is tied;
    has Hash $!Resources is tied;
}
