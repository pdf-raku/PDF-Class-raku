use v6;

use PDF::Doc::Type::Shading::FreeForm;

#| /ShadingType 6 - Coons

class PDF::Doc::Type::Shading::Coons
    is PDF::Doc::Type::Shading::FreeForm {
    #| see [PDF 1.7 TABLE 4.34 Additional entries specific to a type 6 shading dictionary]
    # Coons and FreeForm shading types have identical structure
}
