use v6;
use Test;
use PDF::Grammar::Test :is-json-equiv;
use PDF::DOM::Contents::Op :OpNames;

class T does PDF::DOM::Contents::Op {};
my $t = T.new;

dies-ok {$t.op('TJ', ['grrr'])}, "Text before BT - dies";

is-json-equiv $t.op(BeginText), (:BT[]), 'BeginText';

is-json-equiv $t.op('Tf', 'F1', 16), (:Tf[ :name<F1>, :real(16) ]), 'Tf';
is-json-equiv $t.op('scn', 0.30, 'int' => 1, 0.21, 'P2'), (:scn[ :real(.30), :int(1), :real(.21), :name<P2> ]), 'scn';
is-json-equiv $t.op('TJ', [ 'hello', 42, 'world']), (:TJ[ :array[ :literal<hello>, :int(42), :literal<world> ] ]), 'TJ';
is-json-equiv $t.op(SetStrokeColorSpace, 'DeviceGray'), (:CS[ :name<DeviceGray> ]), 'Named operator';
dies-ok {$t.op('Tf', 42, 125)}, 'invalid argument dies';
dies-ok {$t.op('Junk', 42)}, 'invalid operator dies';
dies-ok {$t.content}, 'content with unclosed "BT" - dies';

is-json-equiv $t.op(EndText), (:ET[]), 'EndText';

$t.op(Save);
dies-ok {$t.content}, 'content with unclosed "q" (gsave) - dies';
$t.op(Restore);

lives-ok {$t.content}, 'content with matching BT ... ET  q ... Q - lives';

done;

