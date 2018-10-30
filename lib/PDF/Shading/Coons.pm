use v6;

use PDF::Shading::FreeForm;

#| /ShadingType 6 - Coons

class PDF::Shading::Coons
    is PDF::Shading::FreeForm {
    use ISO_32000::Type_6_Shading;
    also does ISO_32000::Type_6_Shading;
    #| see [PDF 32000 Table 84 - Additional Entries Specific to a Type 6 Shading Dictionary]
    # Coons and FreeForm shading types have identical structure
}
