use v6;
use Test;

plan 13;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
15 0 obj% Pattern definition
<< /Type /Pattern
/PatternType 1% Tiling pattern
/PaintType 1% Colored
/TilingType 2
/BBox [ 0 0 100 100 ]
/XStep 100
/YStep 100
/Resources 16 0 R
/Matrix [ 0.4 0.0 0.0 0.4 0.0 0.0 ]
/Length 183
>>
stream
BT% Begin text object
/F1 1 Tf% Set text font and size
64 0 0 64 7.1771 2.4414 Tm% Set text matrix
0 Tc% Set character spacing
0 Tw% Set word spacing
1.0 0.0 0.0 rg% Set nonstroking color to red
( \001 ) Tj% Show spade glyph
0.7478 −0.007 TD% Move text position
0.0 1.0 0.0 rg% Set nonstroking color to green
( \002 ) Tj% Show heart glyph
−0.7323 0.7813 TD% Move text position
0.0 0.0 1.0 rg% Set nonstroking color to blue
( \003 ) Tj% Show diamond glyph
0.6913 0.007 TD% Move text position
0.0 0.0 0.0 rg% Set nonstroking color to black
( \004 ) Tj% Show club glyph
ET% End text object
endstream
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast, :$input);
is $ind-obj.obj-num, 15, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $pattern-obj = $ind-obj.object;
isa-ok $pattern-obj, ::('PDF::DOM::Type')::('Pattern');
is $pattern-obj.Type, 'Pattern', '$.Type accessor';
ok !$pattern-obj.Subtype.defined, '$.Subtype accessor';
is-json-equiv $pattern-obj.BBox, [ 0, 0, 100, 100 ], '$.BBox accessor';
$pattern-obj.gfx.ops.push: '% The end';
$pattern-obj.cb-finish;

my $contents = $pattern-obj.decoded;
is $contents.lines[0], 'q', 'first content line';
is $contents.lines[1], "BT\% Begin text object", 'second content line';
is $contents.lines[*-5], "ET\% End text object", 'fifth last content line';
is $contents.lines[*-4], 'Q', 'fourth last content line is a grestore';
is $contents.lines[*-3], 'q', 'third last content line is a gsave';
is $contents.lines[*-2], '% The end', 'second last content line';
is $contents.lines[*-1], 'Q', 'last content line is a grestore';
