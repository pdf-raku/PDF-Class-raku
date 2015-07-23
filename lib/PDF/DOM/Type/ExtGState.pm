use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Numeric:_ $!LW is tied;
    has Int:_ $!LC is tied;
    has Int:_ $!LJ is tied;
    has Numeric:_ $!ML is tied;
    has Array:_ $!D is tied;
    has Str:_ $!RI is tied;
    has Bool:_ $!OP is tied;
    has Bool:_ $!op is tied;
    has Int:_ $!OPM is tied;
    has Array:_ $!Font is tied;
    has $!BG is tied;
    has $!BG2 is tied;
    has $!UCR is tied;
    has $!UCR2 is tied;
    has $!TR is tied;
    has $!TR2 is tied;
    has $!HT is tied;
    has Numeric:_ $!FL is tied;
    has Numeric:_ $!SM is tied;
    has Bool:_ $!SA is tied;
    has $!BM is tied;
    has $!SMask is tied;
    has Numeric:_ $!CA is tied;
    has Numeric:_ $!ca is tied;
    has Bool:_ $!AIS is tied;
    has Bool:_ $!TK is tied;

}
