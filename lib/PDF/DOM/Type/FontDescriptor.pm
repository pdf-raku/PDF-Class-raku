use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method FontName is rw returns Str { self<FontName> }
    method FontFamily is rw returns Str:_ { self<FontFamily> }
    method FontStretch is rw returns Str:_ { self<FontStretch> }
    method FontWeight is rw returns Numeric:_ { self<FontWeight> }
    method Flags is rw returns Int:_ { self<Flags> }
    method FontBBox is rw returns Array:_ { self<FontBBox> }
    method ItalicAngle is rw returns Numeric:_ { self<ItalicAngle> }
    method Ascent is rw returns Numeric:_ { self<Ascent> }
    method Descent is rw returns Numeric:_ { self<Descent> }
    method Leading is rw returns Numeric:_ { self<Leading> }
    method CapHeight is rw returns Numeric:_ { self<CapHeight> }
    method XHeight is rw returns Numeric:_ { self<XHeight> }
    method StemV is rw returns Numeric:_ { self<StemV> }
    method AvgWidth is rw returns Numeric:_ { self<AvgWidth> }
    method MaxWidth is rw returns Numeric:_ { self<MaxWidth> }
    method MissingWidth is rw returns Numeric:_ { self<MissingWidth> }
    method FontFile is rw returns PDF::Object::Stream:_ { self<FontFile> }
    method FontFile2 is rw returns PDF::Object::Stream:_ { self<FontFile2> }
    method FontFile3 is rw returns PDF::Object::Stream:_ { self<FontFile3> }
    method CharSet is rw returns Str:_ { self<CharSet> }


}
