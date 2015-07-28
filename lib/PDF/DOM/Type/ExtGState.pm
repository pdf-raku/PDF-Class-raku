use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    has Numeric $!LW is entry;
    has Int $!LC is entry;
    has Int $!LJ is entry;
    has Numeric $!ML is entry;
    has Array $!D is entry;
    has PDF::Object::Name $!RI is entry;
    has Bool $!OP is entry;
    has Bool $!op is entry;
    has Int $!OPM is entry;
    has Array $!Font is entry;
    has $!BG is entry;
    has $!BG2 is entry;
    has $!UCR is entry;
    has $!UCR2 is entry;
    has $!TR is entry;
    has $!TR2 is entry;
    has $!HT is entry;
    has Numeric $!FL is entry;
    has Numeric $!SM is entry;
    has Bool $!SA is entry;
    has $!BM is entry;
    has $!SMask is entry;
    has Numeric $!CA is entry;
    has Numeric $!ca is entry;
    has Bool $!AIS is entry;
    has Bool $!TK is entry;

}
