use v6;

class PDF::ColorSpace::Pattern {
    use PDF::ColorSpace;
    also is PDF::ColorSpace;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Class::Defs :ColorSpace;
    # see [PDF 32000 Section 8.6.6.2 - Pattern Color Spaces]
    has ColorSpace $.Colorspace is index(1);
}
