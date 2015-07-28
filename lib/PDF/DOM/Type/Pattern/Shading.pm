use v6;

use PDF::Object::Dict;
use PDF::DOM::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::DOM::Type::Pattern::Shading
    is PDF::Object::Dict
    does PDF::DOM::Type::Pattern {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    # see [PDF 1.7 TABLE 4.26 Entries in a type 2 pattern dictionary]
    use PDF::DOM::Type::Shading;
    has PDF::DOM::Type::Shading $!Shading is entry(:required); #| (Required) A shading object (see below) defining the shading pattern’s gradient fill.
    has Hash $!ExtGState is entry;          #| (Optional) A graphics state parameter dictionary
}
