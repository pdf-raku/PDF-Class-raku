use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Array $!Rect; method Rect { self.tie(:$!Rect) };
    has Str:_ $!Contents; method Contents { self.tie(:$!Contents) };
    has Hash:_ $!P; method P { self.tie(:$!P) };
    has Str:_ $!NM; method NM { self.tie(:$!NM) };
    has Str:_ $!M; method M { self.tie(:$!M) };
    has Int:_ $!F; method F { self.tie(:$!F) };
    has Hash:_ $!AP; method AP { self.tie(:$!AP) };
    has Str:_ $!AS; method AS { self.tie(:$!AS) };
    has Array:_ $!Border; method Border { self.tie(:$!Border) };
    has Array:_ $!C; method C { self.tie(:$!C) };
    has Int:_ $!StructParent; method StructParent { self.tie(:$!StructParent) };
    has Hash:_ $!OC; method OC { self.tie(:$!OC) };

}
