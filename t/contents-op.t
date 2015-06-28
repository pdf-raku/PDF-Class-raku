use v6;
use Test;
use PDF::DOM::Contents::Op;

class t does PDF::DOM::Contents::Op {};

is-deeply t.op('Tf', 'F1', 16), (:Tf[ :name<F1>, :real(16) ]), 'Tf';
is-deeply t.op('scn', 0.30, 0.75, 0.21, 'P2'), (:scn[ :real(.30), :real(.75), :real(.21), :name<P2> ]), 'scn';
dies-ok {t.op('Tf', 42, 125)}, 'invalid argument dies';
dies-ok {t.op('Junk', 42)}, 'invalid operator dies';
done;

