use v6;
use Test;
use PDF::Grammar::Test :is-json-equiv;
use PDF::DOM::Op :OpNames;

class T does PDF::DOM::Op {};
my $g = T.new;

dies-ok {$g.op('TJ', ['grrr'])}, "Text before BT - dies";

is-json-equiv $g.op(BeginText), (:BT[]), 'BeginText';

is-json-equiv $g.op('Tf', 'F1', 16), (:Tf[ :name<F1>, :real(16) ]), 'Tf';
is $g.FontKey, 'F1', '$g.FontKey';
is $g.FontSize, 16, '$g.FontSize';

is $g.TextLeading, 0, '$g.TextLeading - initial';
$g.op(SetTextLeading, 22);
is $g.TextLeading, 22, '$g.TextLeading - updated';

is $g.WordSpacing, 0, '$g.WordSpacing - initial';
$g.op(SetWordSpacing, 7.5);
is $g.WordSpacing, 7.5, '$g.WordSpacing - updated';

is-json-equiv $g.TextMatrix, [1, 0, 0, 1, 0, 0], '$g.TexrMatrix - initial';
$g.op(SetTextMatrix, 10, 1, 15, 2, 3, 4);
is-json-equiv $g.TextMatrix, [10, 1, 15, 2, 3, 4], '$g.TextMatrix - updated';
$g.op(SetTextMatrix, 10, 1, 15, 2, 3, 4);
is-json-equiv $g.TextMatrix, [10, 1, 15, 2, 3, 4], '$g.TextMatrix - updated again';

$g.op(Save);
is-json-equiv $g.GraphicsMatrix, [1, 0, 0, 1, 0, 0], '$g.GraphicsMatrix - initial';
$g.op(ConcatMatrix, 10, 1, 15, 2, 3, 4);
is-json-equiv $g.GraphicsMatrix, [10, 1, 15, 2, 3, 4], '$g.GraphicMatrix - updated';
$g.op(ConcatMatrix, 10, 1, 15, 2, 3, 4);
is-json-equiv $g.GraphicsMatrix, [115, 12, 180, 19, 93, 15], '$g.GraphicMatrix - updated again';

is-json-equiv $g.op('scn', 0.30, 'int' => 1, 0.21, 'P2'), (:scn[ :real(.30), :int(1), :real(.21), :name<P2> ]), 'scn';
is-json-equiv $g.op('TJ', [ 'hello', 42, 'world']), (:TJ[ :array[ :literal<hello>, :int(42), :literal<world> ] ]), 'TJ';
is-json-equiv $g.op(SetStrokeColorSpace, 'DeviceGray'), (:CS[ :name<DeviceGray> ]), 'Named operator';
dies-ok {$g.op('Tf', 42, 125)}, 'invalid argument dies';
dies-ok {$g.op('Junk', 42)}, 'invalid operator dies';
dies-ok {$g.content}, 'content with unclosed "BT" - dies';

is-json-equiv $g.op(EndText), (:ET[]), 'EndText';

ok !$g.TextMatrix.defined, '$g.TextMatrix - outside of text block';
is-json-equiv $g.GraphicsMatrix, [115, 12, 180, 19, 93, 15], '$g.GraphicMatrix - outside of text block';

dies-ok {$g.content}, 'content with unclosed "q" (gsave) - dies';
$g.op(Restore);

is-json-equiv $g.GraphicsMatrix, [1, 0, 0, 1, 0, 0, ], '$g.GraphicMatrix - outside of restore';

lives-ok {$g.content}, 'content with matching BT ... ET  q ... Q - lives';

done;

