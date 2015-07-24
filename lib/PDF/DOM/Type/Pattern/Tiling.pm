use v6;

use PDF::Object::Stream;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Tiling
    is PDF::Object::Stream
    does PDF::DOM::Type::Pattern {

    use PDF::Object::Tie;

    has Int $!TilingType is entry(:required);
    has Array $!BBox is entry(:required);
    has Int $!PaintType is entry(:required);
    has Numeric $!XStep is entry(:required);
    has Numeric $!YStep is entry(:required);
    has Hash $!Resources is entry(:required);
}
