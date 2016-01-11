use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type::Pattern;

#| /ShadingType 2 - Axial

class PDF::Doc::Type::Pattern::Shading
    is PDF::DAO::Dict
    does PDF::Doc::Type::Pattern {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    # see [PDF 1.7 TABLE 4.26 Entries in a type 2 pattern dictionary]
    use PDF::Doc::Type::Shading;
    has PDF::Doc::Type::Shading $.Shading is entry(:required); #| (Required) A shading object (see below) defining the shading pattern’s gradient fill.
    has Hash $.ExtGState is entry;          #| (Optional) A graphics state parameter dictionary
}
