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

    has Array $!BBox; method BBox { self.tie($!BBox) };
    has Int $!PatternType; method PatternType { self.tie($!PatternType) };
    has Int $!PaintType; method PaintType { self.tie($!PaintType) };
    has Int $!TilingType; method TilingType { self.tie($!TilingType) };
    has Numeric $!XStep; method XStep { self.tie($!XStep) };
    has Numeric $!YStep; method YStep { self.tie($!YStep) };
    has Array:_ $!Matrix; method Matrix { self.tie($!Matrix) };


}
