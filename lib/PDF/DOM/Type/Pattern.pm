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

    method BBox is rw returns Array { self<BBox> }
    method PatternType is rw returns Int { self<PatternType> }
    method PaintType is rw returns Int { self<PaintType> }
    method TilingType is rw returns Int { self<TilingType> }
    method XStep is rw returns Numeric { self<XStep> }
    method YStep is rw returns Numeric { self<YStep> }
    method Matrix is rw returns Array:_ { self<Matrix> }


}
