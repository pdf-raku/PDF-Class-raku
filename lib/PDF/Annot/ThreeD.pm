use v6;

use PDF::Annot;
use PDF::Class::Type;
use PDF::Class::ThreeD;

class PDF::Annot::ThreeD
    is PDF::Annot
    does PDF::Class::Type
    does PDF::Class::ThreeD {
    use ISO_32000::Three-D_annotation;
    also does ISO_32000::Three-D_annotation;
}
