use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Numeric:_ $!LW; method LW { self.tie($!LW) };
    has Int:_ $!LC; method LC { self.tie($!LC) };
    has Int:_ $!LJ; method LJ { self.tie($!LJ) };
    has Numeric:_ $!ML; method ML { self.tie($!ML) };
    has Array:_ $!D; method D { self.tie($!D) };
    has Str:_ $!RI; method RI { self.tie($!RI) };
    has Bool:_ $!OP; method OP { self.tie($!OP) };
    has Bool:_ $!op; method op { self.tie($!op) };
    has Int:_ $!OPM; method OPM { self.tie($!OPM) };
    has Array:_ $!Font; method Font { self.tie($!Font) };
    has $!BG; method BG { self.tie($!BG) };
    has $!BG2; method BG2 { self.tie($!BG2) };
    has $!UCR; method UCR { self.tie($!UCR) };
    has $!UCR2; method UCR2 { self.tie($!UCR2) };
    has $!TR; method TR { self.tie($!TR) };
    has $!TR2; method TR2 { self.tie($!TR2) };
    has $!HT; method HT { self.tie($!HT) };
    has Numeric:_ $!FL; method FL { self.tie($!FL) };
    has Numeric:_ $!SM; method SM { self.tie($!SM) };
    has Bool:_ $!SA; method SA { self.tie($!SA) };
    has $!BM; method BM { self.tie($!BM) };
    has $!SMask; method SMask { self.tie($!SMask) };
    has Numeric:_ $!CA; method CA { self.tie($!CA) };
    has Numeric:_ $!ca; method ca { self.tie($!ca) };
    has Bool:_ $!AIS; method AIS { self.tie($!AIS) };
    has Bool:_ $!TK; method TK { self.tie($!TK) };

}
