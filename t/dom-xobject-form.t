use v6;
use Test;

plan 9;

use PDF::DOM;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
6 0 obj% Form XObject
<< /Type /XObject
/Subtype /Form
/FormType 1
/BBox [ 0 0 1000 1000 ]
/Matrix [ 1 0 0 1 0 0 ]
/Resources << /ProcSet [ /PDF ] >>
/Length 58
>>
stream
0 0 m
0 200 l
200 200 l
200 0 l
f
endstream
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast, :$input);
is $ind-obj.obj-num, 6, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $xform = $ind-obj.object;
isa-ok $xform, ::('PDF::DOM::Type')::('XObject::Form');
is $xform.Type, 'XObject', '$.Type accessor';
is $xform.Subtype, 'Form', '$.Subtype accessor';
is-json-equiv $xform.Resources, { :ProcSet( [ <PDF> ] ) }, '$.Resources accessor';
is-json-equiv $xform.BBox, [ 0, 0, 1000, 1000 ], '$.BBox accessor';
is $xform.encoded, "0 0 m\n0 200 l\n200 200 l\n200 0 l\nf", '$.encoded accessor';
$xform.gfx.text-move(50,50);
$xform.gfx.ops.push: ('rg' => [ :real(.5), :real(.95), :real(.5), ]);
my $font = $xform.core-font( :family<Helvetica>, :weight<bold> );
$xform.gfx.text('Hello, again!', :$font);
$xform.cb-finish;

my $contents = $xform.decoded;
is-deeply [$contents.lines], [
    'q', '0 0 m', '0 200 l', '200 200 l', '200 0 l', 'f', 'Q',
    'q', '50 50 Td', '0.5 0.95 0.5 rg', '/F1 16 Tf', '17.6 TL', '[ (Hello,) -278 (again!) ] TJ', 'T*', 'Q'
    ], 'finished contents';

my $pdf = PDF::DOM.new;
my $page = $pdf.Pages.add-page;
$page.media-box(230,210);
$page.gfx.do($xform);

$pdf.save-as('t/dom-xobject-form.pdf');
