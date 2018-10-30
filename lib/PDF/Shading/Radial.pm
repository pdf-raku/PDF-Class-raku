use v6;

use PDF::Shading::Axial;

#| /ShadingType 3 - Radial

class PDF::Shading::Radial
    is PDF::Shading::Axial {
    use ISO_32000::Type_3_Shading;
    also does ISO_32000::Type_3_Shading;
    # see [PDF 32000 Table 81 - Additional Entries Specific to a Type 3 Shading Dictionary]
    # Radial and Axial have identical structure
}
