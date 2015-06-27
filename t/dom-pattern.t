use v6;
use Test;

plan 13;

use PDF::DOM;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;

my $actions = PDF::Grammar::PDF::Actions.new;

# example taken from PDF 1.7 Specification

my $input = q:to"--END-OBJ--";
15 0 obj% Pattern definition
<< /Type /Pattern
/PatternType 1% Tiling pattern
/PaintType 1% Colored
/TilingType 2
/BBox [ 0 0 100 100 ]
/XStep 100
/YStep 100
/Resources <<>>
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
(«) Tj% Show spade glyph
0.7478 -0.007 TD% Move text position
0.0 1.0 0.0 rg% Set nonstroking color to green
(*) Tj% Show heart glyph
-0.7323 0.7813 TD% Move text position
0.0 0.0 1.0 rg% Set nonstroking color to blue
(ª) Tj% Show diamond glyph
0.6913 0.007 TD% Move text position
0.0 0.0 0.0 rg% Set nonstroking color to black
(©) Tj% Show club glyph
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
$pattern-obj.core-font('ZapfDingbats');
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

my $page-content = q:to"--END-OBJ2--";
30 0 obj% Contents of page
<< /Length 1252 >>
stream
0.0 G% Set stroking color to black
1.0 1.0 0.0 rg% Set nonstroking color to yellow
25 175 175 -150 re% Construct rectangular path
f% Fill path
/Pattern cs% Set pattern color space
/P1 scn% Set pattern as nonstroking color
99.92 49.92 m% Start new path
99.92 77.52 77.52 99.92 49.92 99.92 c% Construct lower-left circle
22.32 99.92 -0.08 77.52 -0.08 49.92 c
-0.08 22.32 22.32 -0.08 49.92 -0.08 c
77.52 -0.08 99.92 22.32 99.92 49.92 c
B% Fill and stroke path
224.96 49.92 m% Start new path
224.96 77.52 202.56 99.92 174.96 99.92 c% Construct lower-right circle
147.36 99.92 124.96 77.52 124.96 49.92 c
124.96 22.32 147.36 -0.08 174.96 -0.08 c
202.56 -0.08 224.96 22.32 224.96 49.92 c
B% Fill and stroke path
87.56 201.70 m% Start new path
63.66 187.90 55.46 157.32 69.26 133.40 c% Construct upper circle
83.06 109.50 113.66 101.30 137.56 115.10 c
161.46 128.90 169.66 159.50 155.86 183.40 c
142.06 207.30 111.46 215.50 87.56 201.70 c
B% Fill and stroke path
50 50 m% Start new path
175 50 l% Construct triangular path
112.5 158.253 l
b% Close, fill, and stroke path
endstream
endobj
--END-OBJ2--

PDF::Grammar::PDF.parse($page-content, :$actions, :rule<ind-obj>)
    // die "parse failed";
$ast = $/.ast;
$ind-obj = PDF::Storage::IndObj.new( |%$ast, :input($page-content));
my $content-obj = $ind-obj.object;

my $pdf = PDF::DOM.new;
my $page = $pdf.Pages.add-page;
$page.media-box(230,210);
$page.resource($pattern-obj);
$page<Contents> = $content-obj;

$pdf.save-as('t/dom-pattern.pdf');
