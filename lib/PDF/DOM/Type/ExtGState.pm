use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Numeric $!LW is entry;
    has Int $!LC is entry;
    has Int $!LJ is entry;
    has Numeric $!ML is entry;
    has Array $!D is entry;
    has Str $!RI is entry;
    has Bool $!OP is entry;
    has Bool $!op is entry;
    has Int $!OPM is entry;
    has Array $!Font is entry;
    has $!BG is entry(:required);
    has $!BG2 is entry(:required);
    has $!UCR is entry(:required);
    has $!UCR2 is entry(:required);
    has $!TR is entry(:required);
    has $!TR2 is entry(:required);
    has $!HT is entry(:required);
    has Numeric $!FL is entry;
    has Numeric $!SM is entry;
    has Bool $!SA is entry;
    has $!BM is entry(:required);
    has $!SMask is entry(:required);
    has Numeric $!CA is entry;
    has Numeric $!ca is entry;
    has Bool $!AIS is entry;
    has Bool $!TK is entry;

}
