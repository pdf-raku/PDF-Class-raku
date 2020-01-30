use v6;

use PDF::ColorSpace;

class PDF::ColorSpace::Pattern
    is PDF::ColorSpace {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    # see [PDF 32000 Section 8.6.6.2 - Pattern Color Spaces]
    my subset ColorSpaceLike where PDF::COS::Name|PDF::ColorSpace;
    has ColorSpaceLike $.Colorspace is index(1);
}
