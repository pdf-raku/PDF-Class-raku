use v6;

use PDF::Struct::Shading::Axial;

#| /ShadingType 3 - Radial

class PDF::Struct::Shading::Radial
    is PDF::Struct::Shading::Axial {
    # see [PDF TABLE 4.31 Additional entries specific to a type 3 shading dictionary]
    # Radial and Axial have identical structure
}
