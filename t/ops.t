use v6;
use Test;
use PDF::Grammar::Test :is-json-equiv;
use PDF::DOM::Op :OpNames;

class T does PDF::DOM::Op {};
my $g = T.new;

dies-ok {$g.op('TJ', ['grrr'])}, "Text before BT - dies";

is-json-equiv $g.BeginText, (:BT[]), 'BeginText';

is-json-equiv $g.op('Tf', 'F1', 16), (:Tf[ :name<F1>, :real(16) ]), 'Tf';
is $g.FontKey, 'F1', '$g.FontKey';
is $g.FontSize, 16, '$g.FontSize';

is $g.TextLeading, 0, '$g.TextLeading - initial';
$g.SetTextLeading( 22);
is $g.TextLeading, 22, '$g.TextLeading - updated';

is $g.WordSpacing, 0, '$g.WordSpacing - initial';
$g.SetWordSpacing( 7.5);
is $g.WordSpacing, 7.5, '$g.WordSpacing - updated';

is $g.HorizScaling, 100, '$g.HorizScaling - initial';
$g.SetHorizScaling( 150);
is $g.HorizScaling, 150, '$g.HorizScaling - updated';

is $g.TextRise, 0, '$g.TextRise - initial';
$g.SetTextRise( 1.5);
is $g.TextRise, 1.5, '$g.TextRise - updated';

is $g.CharSpacing, 0, '$g.CharSpacing - initial';
$g.SetCharSpacing( -.5);
is $g.CharSpacing, -.5, '$g.CharSpacing - updated';

is-json-equiv $g.TextMatrix, [1, 0, 0, 1, 0, 0], '$g.TextMatrix - initial';
$g.SetTextMatrix( 10, 1, 15, 2, 3, 4);
is-json-equiv $g.TextMatrix, [10, 1, 15, 2, 3, 4], '$g.TextMatrix - updated';
$g.SetTextMatrix( 10, 1, 15, 2, 3, 4);
is-json-equiv $g.TextMatrix, [10, 1, 15, 2, 3, 4], '$g.TextMatrix - updated again';

$g.op(Save);
is-json-equiv $g.GraphicsMatrix, [1, 0, 0, 1, 0, 0], '$g.GraphicsMatrix - initial';
$g.ConcatMatrix( 10, 1, 15, 2, 3, 4);
is-json-equiv $g.GraphicsMatrix, [10, 1, 15, 2, 3, 4], '$g.GraphicMatrix - updated';
$g.ConcatMatrix( 10, 1, 15, 2, 3, 4);
is-json-equiv $g.GraphicsMatrix, [115, 12, 180, 19, 93, 15], '$g.GraphicMatrix - updated again';

is-json-equiv $g.op('scn', 0.30, 'int' => 1, 0.21, 'P2'), (:scn[ :real(.30), :int(1), :real(.21), :name<P2> ]), 'scn';
is-json-equiv $g.op('TJ', [ 'hello', 42, 'world']), (:TJ[ :array[ :literal<hello>, :int(42), :literal<world> ] ]), 'TJ';
is-json-equiv $g.SetStrokeColorSpace('DeviceGray'), (:CS[ :name<DeviceGray> ]), 'Named operator';
dies-ok {$g.op('Tf', 42, 125)}, 'invalid argument dies';
dies-ok {$g.op('Junk', 42)}, 'invalid operator dies';
dies-ok {$g.content}, 'content with unclosed "BT" - dies';

is-json-equiv $g.op(EndText), (:ET[]), 'EndText';

ok !$g.TextMatrix.defined, '$g.TextMatrix - outside of text block';
is-json-equiv $g.GraphicsMatrix, [115, 12, 180, 19, 93, 15], '$g.GraphicMatrix - outside of text block';

dies-ok {$g.content}, 'content with unclosed "q" (gsave) - dies';
$g.Restore;

is-json-equiv $g.GraphicsMatrix, [1, 0, 0, 1, 0, 0, ], '$g.GraphicMatrix - outside of restore';

lives-ok {$g.content}, 'content with matching BT ... ET  q ... Q - lives';

$g = T.new;

$g.ops("175 720 m 175 700 l 300 800 400 720 v h S");
is-json-equiv $g.ops, [:m[:int(175), :int(720)],
		       :l[:int(175), :int(700)],
		       :v[:int(300), :int(800), :int(400), :int(720)],
		       :h[],
		       :S[],
    ], 'basic parse';

my $image-block = 'BI                  % Begin inline image object
    /W 17           % Width in samples
    /H 17           % Height in samples
    /CS /RGB        % Colour space
    /BPC 8          % Bits per component
    /F [/A85 /LZW]  % Filters
ID                  % Begin image data
J1/gKA>.]AN&J?]-<HW]aRVcg*bb.\eKAdVV%/PcZ
%…Omitted data…
%R.s(4KE3&d&7hb*7[%Ct2HCqC~>
EI';

$g.ops($image-block);
is-json-equiv $g.ops[*-3], {:BI[:dict{:BPC(:int(8)),
				      :CS(:name<RGB>),
				      :F(:array[:name<A85>, :name<LZW>]),
				      :H(:int(17)),
				      :W(:int(17)) }]}, 'Image BI';
is-json-equiv $g.ops[*-2], {:ID[:encoded("J1/gKA>.]AN\&J?]-<HW]aRVcg*bb.\\eKAdVV\%/PcZ\n\%…Omitted data…\n\%R.s(4KE3\&d\&7hb*7[\%Ct2HCqC~>")]}, 'Image ID';
is-json-equiv $g.ops[*-1], 'EI', 'Image EI';

BEGIN our $compile-time = PDF::DOM::Op.parse("BT/F1 16 Tf\n(Hi)Tj ET");
is-json-equiv $compile-time[*-1], (:ET[]), 'compile time ops parse';
$g.ops( $compile-time);
is-json-equiv [ $g.ops[*-4..*] ], [ :BT[],
				    :Tf[:name<F1>, :int(16)],
				    :Tj[:literal<Hi>],
				    :ET[] ], 'Text block parse';

done;

