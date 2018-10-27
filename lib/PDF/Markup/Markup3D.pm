use v6;

use PDF::COS::Dict;
use PDF::Class::Type;
use PDF::Class::ThreeD;

class PDF::Markup::Markup3D
    is PDF::COS::Dict
    does PDF::Class::Type
    does PDF::Class::ThreeD {
    use ISO_32000::Three-D_annotation;
    also does ISO_32000::Three-D_annotation;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    has PDF::COS::Name  $.Subtype is entry(:required) where 'Markup3D'; #| Required) The type of external data that this dictionary describes; shall be Markup3D for a 3D comment. The only defined value is Markup3D.
}
