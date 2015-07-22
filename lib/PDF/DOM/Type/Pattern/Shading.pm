use v6;

use PDF::Object::Dict;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Shading
    is PDF::Object::Dict
    does PDF::DOM::Type::Pattern {

    use PDF::DOM::Type::Shading;
    subset NameOrShading of Any where Str | PDF::DOM::Type::Shading;
    has NameOrShading $!Shading; method Shading { self.tie($!Shading) };
    has Hash:_ $!ExtGState;  method ExtGState { self.tie($!ExtGState) };
}
