use v6;

use PDF::Object::Dict;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Shading
    is PDF::Object::Dict
    does PDF::DOM::Type::Pattern {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    use PDF::DOM::Type::Shading;
    subset NameOrShading of Any where PDF::Object::Name | PDF::DOM::Type::Shading;
    has NameOrShading $!Shading is entry(:required);
    has Hash $!ExtGState is entry;
}
