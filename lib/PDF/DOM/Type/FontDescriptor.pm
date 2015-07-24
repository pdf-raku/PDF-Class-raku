use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /FontDescriptor - the FontDescriptor dictionary

class PDF::DOM::Type::FontDescriptor
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Str $!FontName is entry(:required);
    has Str $!FontFamily is entry;
    has Str $!FontStretch is entry;
    has Numeric $!FontWeight is entry;
    has Int $!Flags is entry;
    has Array $!FontBBox is entry;
    has Numeric $!ItalicAngle is entry;
    has Numeric $!Ascent is entry;
    has Numeric $!Descent is entry;
    has Numeric $!Leading is entry;
    has Numeric $!CapHeight is entry;
    has Numeric $!XHeight is entry;
    has Numeric $!StemV is entry;
    has Numeric $!AvgWidth is entry;
    has Numeric $!MaxWidth is entry;
    has Numeric $!MissingWidth is entry;
    has PDF::Object::Stream $!FontFile is entry;
    has PDF::Object::Stream $!FontFile2 is entry;
    has PDF::Object::Stream $!FontFile3 is entry;
    has Str $!CharSet is entry;


}
