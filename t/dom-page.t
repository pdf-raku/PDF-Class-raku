use v6;
use Test;

plan 31;

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
  /MediaBox [0 0 595 842]
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 4, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $page = $ind-obj.object;
isa-ok $page, ::('PDF::DOM::Type')::('Page');
is $page.Type, 'Page', '$.Type accessor';
my $dummy-stream = PDF::Object::Stream.new( :decoded('%dummy stream') );
is $page<Parent>, (:ind-ref[3, 0]), '$page<Parent>';
is $page.Resources, { :Font{ :F1( :ind-ref[7, 0] )}, :ProcSet( :ind-ref[6, 0]) }, '$.Resources accessor';

is-deeply $ind-obj.ast, $ast, 'ast regeneration';

$page.Contents = $dummy-stream;
is-deeply $page.Contents, ($dummy-stream), '$.Contents accessor';
is-deeply $page.contents, [$dummy-stream], '$.contents accessor';

my $font = $page.core-font( 'Helvetica' );
isa-ok $font, ::('PDF::DOM::Type::Font::Type1');
is $font.font-obj.FontName, 'Helvetica', '.FontName';
my $font-again = $page.core-font( 'Helvetica' );
is-deeply $font-again, $font, 'core font caching';
is-deeply [$page.Resources<Font>.keys.sort], [<F1 F2>], 'font resource entries';
my $font2 = $page.core-font( :family<Helvetica>, :weight<bold> );
is $font2.font-obj.FontName, 'Helvetica-Bold', '.FontName';
is-deeply [$page.Resources<Font>.keys.sort], [<F1 F2 F3>], 'font resource entries';

is-json-equiv $page.MediaBox, [0, 0, 595, 842], '$.MediaBox accessor';
is-json-equiv $page.media-box, [0, 0, 595, 842], '$.media-box accessor';

$page<MediaBox>:delete;
is-json-equiv $page.media-box, [0, 0, 612, 792], 'media-box - default';

$page.media-box(150,200);
is-json-equiv $page.media-box, [0, 0, 150, 200], 'media-box - 2 arg setter';

$page.media-box(-3,-3,253,303);
is-json-equiv $page.media-box, [-3, -3, 253, 303], 'media-box - 4 arg setter';
is-json-equiv $page.MediaBox, [-3, -3, 253, 303], '.MediaBox accessor';
is-json-equiv $page<MediaBox>, [-3, -3, 253, 303], '<MediaBox> accessor';

$page.gfx.ops.push: ('Tj' => [ :literal('Hello, world!') ]);
$page.cb-finish;

my $contents = $page.Contents;
isa-ok $contents, Array, 'finished Contents';
is-deeply +$contents, 3, 'finished Contents count';

isa-ok $contents[0], ::('PDF::Object::Stream'), 'finished Contents';
is $contents[0].decoded, "BT\nq\nET\n", 'finished Contents pretext';
is $contents[1].decoded, '%dummy stream', 'finished Contents existing text';
is-deeply [$contents[2].decoded.lines], ['', 'BT', 'Q', 'q', '(Hello, world!) Tj', 'Q', 'ET'], 'finished Contents post-text';

my $xobject = $page.to-xobject;
isa-ok $xobject, ::('PDF::DOM::Type::XObject::Form');
is-deeply $xobject.BBox, $page.MediaBox, 'xobject copied BBox';
is-deeply [$xobject.decoded.lines], ['BT', 'q', 'ET',
                                     '%dummy stream',
                                     'BT', 'Q', 'q', '(Hello, world!) Tj', 'Q', 'ET' ], 'xobject decoded';


