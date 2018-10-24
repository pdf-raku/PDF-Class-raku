use v6;

use PDF::Shading::FreeForm;

#| /ShadingType 7 - Tensor

class PDF::Shading::Tensor
    is PDF::Shading::FreeForm {
    use ISO_32000::Type_6_Shading;
    also does ISO_32000::Type_6_Shading;
    # Tensor and FreeForm shading types have identical structure
}
