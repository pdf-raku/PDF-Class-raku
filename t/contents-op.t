use v6;
use Test;
use PDF::DOM::Contents::Op;

class T does PDF::DOM::Contents::Op {};
my $t = T.new;

is-deeply $t.op('Tf', 'F1', 16)[*-1], (:Tf[ :name<F1>, :real(16) ]), 'Tf';
is-deeply $t.op('scn', 0.30, 'int' => 1, 0.21, 'P2')[*-1], (:scn[ :real(.30), :int(1), :real(.21), :name<P2> ]), 'scn';
is-deeply $t.op('TJ', [ 'hello', 42, 'world'])[*-1], (:TJ[ :array[ :literal<hello>, :int(42), :literal<world> ] ]), 'TJ';
dies-ok {$t.op('Tf', 42, 125)}, 'invalid argument dies';
dies-ok {$t.op('Junk', 42)}, 'invalid operator dies';
done;

