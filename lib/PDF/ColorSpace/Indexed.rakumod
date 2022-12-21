use v6;


class PDF::ColorSpace::Indexed {
    use PDF::ColorSpace;
    also is PDF::ColorSpace;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::Stream;
    use PDF::COS::ByteString;
    use PDF::Class::Defs :ColorSpace;

    # see [PDF 32000 Section 8.6.6.3 Indexed Color Spaces]

    has ColorSpace $.Base is index(1);

    has UInt $.Hival is index(2);

    my subset LookupLike where PDF::COS::Stream|PDF::COS::ByteString;
    has LookupLike $.Lookup is index(3);

}
