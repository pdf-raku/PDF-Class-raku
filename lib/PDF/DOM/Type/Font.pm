use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has $.font-obj handles <encode decode height stringwidth kern>;

    has Str $!Name; method Name { self.tie(:$!Name) };
    has Str:_ $!BaseFont; method BaseFont { self.tie(:$!BaseFont) };
    has $!Encoding; method Encoding { self.tie(:$!Encoding) };

}

