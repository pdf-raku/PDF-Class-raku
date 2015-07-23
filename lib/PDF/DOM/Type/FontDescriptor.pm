use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Str $!FontName is tied;
    has Str:_ $!FontFamily is tied;
    has Str:_ $!FontStretch is tied;
    has Numeric:_ $!FontWeight is tied;
    has Int:_ $!Flags is tied;
    has Array:_ $!FontBBox is tied;
    has Numeric:_ $!ItalicAngle is tied;
    has Numeric:_ $!Ascent is tied;
    has Numeric:_ $!Descent is tied;
    has Numeric:_ $!Leading is tied;
    has Numeric:_ $!CapHeight is tied;
    has Numeric:_ $!XHeight is tied;
    has Numeric:_ $!StemV is tied;
    has Numeric:_ $!AvgWidth is tied;
    has Numeric:_ $!MaxWidth is tied;
    has Numeric:_ $!MissingWidth is tied;
    has PDF::Object::Stream:_ $!FontFile is tied;
    has PDF::Object::Stream:_ $!FontFile2 is tied;
    has PDF::Object::Stream:_ $!FontFile3 is tied;
    has Str:_ $!CharSet is tied;


}
