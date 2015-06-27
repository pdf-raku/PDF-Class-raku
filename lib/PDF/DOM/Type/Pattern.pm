use v6;

use PDF::Object::Stream;
use PDF::DOM::Type;
use PDF::DOM::Contents;
use PDF::DOM::Resources;

class PDF::DOM::Type::Pattern
    is PDF::Object::Stream
    does PDF::DOM::Type
    does PDF::DOM::Contents
    does PDF::DOM::Resources {

    method BBox is rw { self<BBox> }
    method PatternType is rw { self<PatternType> }
    method PaintType is rw { self<PaintType> }
    method XStep is rw { self<XStep> }
    method YStep is rw { self<YStep> }
    method Matrix is rw { self<Matrix> }


}
