use v6;

use PDF::Doc::Type::Shading::Axial;

#| /ShadingType 3 - Radial

class PDF::Doc::Type::Shading::Radial
    is PDF::Doc::Type::Shading::Axial {
    # see [PDF TABLE 4.31 Additional entries specific to a type 3 shading dictionary]
    # Radial and Axial have identical structure
}
