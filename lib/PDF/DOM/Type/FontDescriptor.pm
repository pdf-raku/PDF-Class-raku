use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method FontName is rw { self<FontName> }
    method FontFamily is rw { self<FontFamily> }
    method FontStretch is rw { self<FontStretch> }
    method FontWeight is rw { self<FontWeight> }
    method Flags is rw { self<Flags> }
    method FontBBox is rw { self<FontBBox> }
    method ItalicAngle is rw { self<ItalicAngle> }
    method Ascent is rw { self<Ascent> }
    method Descent is rw { self<Descent> }
    method Leading is rw { self<Leading> }
    method CapHeight is rw { self<CapHeight> }
    method XHeight is rw { self<XHeight> }
    method StemV is rw { self<StemV> }
    method AvgWidth is rw { self<AvgWidth> }
    method MaxWidth is rw { self<MaxWidth> }
    method MissingWidth is rw { self<MissingWidth> }
    method FontFile is rw { self<FontFile> }
    method FontFile2 is rw { self<FontFile2> }
    method FontFile3 is rw { self<FontFile3> }
    method CharSet is rw { self<CharSet> }


}
