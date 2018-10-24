use v6;

use PDF::Shading::FreeForm;

#| /ShadingType 6 - Coons

class PDF::Shading::Coons
    is PDF::Shading::FreeForm {
    use ISO_32000::Type_6_Shading;
    also does ISO_32000::Type_6_Shading;
    #| see [PDF 1.7 TABLE 4.34 Additional entries specific to a type 6 shading dictionary]
    # Coons and FreeForm shading types have identical structure
}
