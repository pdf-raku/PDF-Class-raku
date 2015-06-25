use v6;
use Test;

plan 25;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Object::Stream;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
4 0 obj
<<
  /Type /Page
  /Parent 3 0 R
  /Resources << /Font << /F1 7 0 R >>/ProcSet 6 0 R >>
  /MediaBox [0 0 612 792]
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
isa-ok $page-obj, ::('PDF::DOM::Type')::('Page');
is $page-obj.Type, 'Page', '$.Type accessor';
my $dummy-stream = PDF::Object::Stream.new( :decoded('%dummy stream') );
is $page-obj.Parent, (:ind-ref[3, 0]), '$.Parent accessor';
is $page-obj.Resources, { :Font{ :F1( :ind-ref[7, 0] )}, :ProcSet( :ind-ref[6, 0]) }, '$.Resources accessor';
is-json-equiv $page-obj.MediaBox, [0, 0, 612, 792], '$.MediaBox accessor';

is-deeply $ind-obj.ast, $ast, 'ast regeneration';

$page-obj.Contents = $dummy-stream;
is-deeply $page-obj.Contents, ($dummy-stream), '$.Contents accessor';
is-deeply $page-obj.contents, [$dummy-stream], '$.contents accessor';

my $font = $page-obj.core-font( 'Helvetica' );
isa-ok $font, ::('PDF::DOM::Type::Font::Type1');
is $font.font-obj.FontName, 'Helvetica', '.FontName';
my $font-again = $page-obj.core-font( 'Helvetica' );
is-deeply $font-again, $font, 'core font caching';
is-deeply [$page-obj.Resources<Font>.keys.sort], [<F1 F2>], 'font resource entries';
my $font2 = $page-obj.core-font( :family<Helvetica>, :weight<bold> );
is $font2.font-obj.FontName, 'Helvetica-Bold', '.FontName';
is-deeply [$page-obj.Resources<Font>.keys.sort], [<F1 F2 F3>], 'font resource entries';

$page-obj.gfx.ops.push: ('Tj' => [ :literal('Hello, world!') ]);
$page-obj.cb-finish;

my $contents = $page-obj.Contents;
isa-ok $contents, Array, 'finished Contents';
is-deeply +$contents, 3, 'finished Contents count';

isa-ok $contents[0], ::('PDF::Object::Stream'), 'finished Contents';
is $contents[0].decoded, "q\n", 'finished Contents pretext';
is $contents[1].decoded, '%dummy stream', 'finished Contents existing text';
is-deeply [$contents[2].decoded.lines], ['', 'Q', 'q', '(Hello, world!) Tj', 'Q'], 'finished Contents post-text';

my $xobject = $page-obj.to-xobject;
isa-ok $xobject, ::('PDF::DOM::Type::XObject::Form');
is-deeply $xobject.BBox, $page-obj.MediaBox, 'xobject copied BBox';
is-deeply [$xobject.decoded.lines], ['q', '%dummy stream', 'Q', 'q', '(Hello, world!) Tj', 'Q' ], 'xobject decoded';


