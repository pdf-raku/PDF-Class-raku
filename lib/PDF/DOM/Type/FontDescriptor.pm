use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Str $!FontName; method FontName { self.tie(:$!FontName) };
    has Str:_ $!FontFamily; method FontFamily { self.tie(:$!FontFamily) };
    has Str:_ $!FontStretch; method FontStretch { self.tie(:$!FontStretch) };
    has Numeric:_ $!FontWeight; method FontWeight { self.tie(:$!FontWeight) };
    has Int:_ $!Flags; method Flags { self.tie(:$!Flags) };
    has Array:_ $!FontBBox; method FontBBox { self.tie(:$!FontBBox) };
    has Numeric:_ $!ItalicAngle; method ItalicAngle { self.tie(:$!ItalicAngle) };
    has Numeric:_ $!Ascent; method Ascent { self.tie(:$!Ascent) };
    has Numeric:_ $!Descent; method Descent { self.tie(:$!Descent) };
    has Numeric:_ $!Leading; method Leading { self.tie(:$!Leading) };
    has Numeric:_ $!CapHeight; method CapHeight { self.tie(:$!CapHeight) };
    has Numeric:_ $!XHeight; method XHeight { self.tie(:$!XHeight) };
    has Numeric:_ $!StemV; method StemV { self.tie(:$!StemV) };
    has Numeric:_ $!AvgWidth; method AvgWidth { self.tie(:$!AvgWidth) };
    has Numeric:_ $!MaxWidth; method MaxWidth { self.tie(:$!MaxWidth) };
    has Numeric:_ $!MissingWidth; method MissingWidth { self.tie(:$!MissingWidth) };
    has PDF::Object::Stream:_ $!FontFile; method FontFile { self.tie(:$!FontFile) };
    has PDF::Object::Stream:_ $!FontFile2; method FontFile2 { self.tie(:$!FontFile2) };
    has PDF::Object::Stream:_ $!FontFile3; method FontFile3 { self.tie(:$!FontFile3) };
    has Str:_ $!CharSet; method CharSet { self.tie(:$!CharSet) };


}
