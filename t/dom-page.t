use v6;
use Test;

plan 16;

use PDF::DOM;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
4 0 obj
<<
  /Type /Page
  /Parent 3 0 R
  /Resources << /Font << /F1 7 0 R >>/ProcSet 6 0 R >>
  /MediaBox [0 0 612 792]
  /Contents 5 0 R
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 4, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $page-obj = $ind-obj.object;
isa-ok $page-obj, ::('PDF::DOM')::('Page');
is $page-obj.Type, 'Page', '$.Type accessor';
is $page-obj.Parent, (:ind-ref[3, 0]), '$.Parent accessor';
is $page-obj.Resources, { :Font{ :F1( :ind-ref[7, 0] )}, :ProcSet( :ind-ref[6, 0]) }, '$.Resources accessor';
is-json-equiv $page-obj.MediaBox, [0, 0, 612, 792], '$.MediaBox accessor';
is-deeply $page-obj.Contents, (:ind-ref[5, 0]), '$.Contents accessor';
is-deeply $page-obj.contents, [:ind-ref[5, 0]], '$.contents accessor';
is-deeply $ind-obj.ast, $ast, 'ast regeneration';

$page-obj.gfx.ops.push: ('Tj' => [ :literal('Hello, world!') ]);
$page-obj.cb-finish;

my $contents = $page-obj.Contents;
isa-ok $contents, Array, 'finished Contents';
is-deeply +$contents, 3, 'finished Contents count';

isa-ok $contents[0], ::('PDF::Object::Stream'), 'finished Contents';
is $contents[0].encoded, 'q', 'finished Contents pretext';
is $contents[1], (:ind-ref[5, 0]), 'finished Contents existing text';
is $contents[2].encoded.lines, ['Q', 'q', '(Hello, world!) Tj', 'Q'], 'finished Contents post-text';
