use v6;

use PDF::Shading::Axial;

#| /ShadingType 3 - Radial

class PDF::Shading::Radial
    is PDF::Shading::Axial {
    use ISO_32000::Shading_common;
    use ISO_32000::Type_3_Shading;
    also does ISO_32000::Shading_common;
    also does ISO_32000::Type_3_Shading;
    # see [PDF TABLE 4.31 Additional entries specific to a type 3 shading dictionary]
    # Radial and Axial have identical structure
}
