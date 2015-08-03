use v6;

use PDF::DOM::Type::ColorSpace;

class PDF::DOM::Type::ColorSpace::Separation
    is PDF::DOM::Type::ColorSpace {

    use PDF::Object::Tie;
    use PDF::Object::Name;
    # see [PDF 1.7 Section 4.5.5 Special Color Spaces] 
    has PDF::Object::Name $.Name is index(1);
    subset ArrayOrName of Any where Array | PDF::Object::Name;
    has ArrayOrName $.AlternateSpace is index(2);
    has $.TintTransform is index(3);

}
