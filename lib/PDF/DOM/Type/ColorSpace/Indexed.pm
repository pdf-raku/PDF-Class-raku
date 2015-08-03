use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::Indexed
    is PDF::DOM::Type::ColorSpace {

    use PDF::Object::Tie;
    use PDF::Object::Name;
    use PDF::Object::Stream;
    use PDF::Object::ByteString;
    # see [PDF 1.7 Section 4.5.5 Special Color Spaces] 
    subset ArrayOrName of Any where Array | PDF::Object::Name;
    has ArrayOrName $.Base is index(1);
    has UInt $.Hival is index(2);
    subset StreamOrByteString of Any where PDF::Object::Stream | PDF::Object::ByteString;
    has StreamOrByteString $.Lookup is index(3);

}
