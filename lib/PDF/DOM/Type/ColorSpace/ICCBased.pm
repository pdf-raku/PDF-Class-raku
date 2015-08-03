use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::ICCBased
    is PDF::DOM::Type::ColorSpace {

    use PDF::Object::Name;
    use PDF::Object::Stream;

    # see [PDF 1.7 TABLE 44.16 Additional entries specific to an ICC profile stream dictionary]
    method N returns UInt is rw { self[1]<N> }
    subset ArrayOrName of Any where Array | PDF::Object::Name;
    method Alternate returns ArrayOrName:_ is rw { self[1]<Alternate> }
    method Range returns Array:_ is rw { self[1]<Range> }
    method Metadata returns PDF::Object::Stream:_ is rw { self[1]<MetaData> }

}
