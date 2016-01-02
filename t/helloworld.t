use v6;
use Test;

use PDF::Grammar::Test :is-json-equiv;
use PDF::DOM;
use PDF::DOM::Op :OpNames;

# ensure consistant document ID generation
srand(123456);

my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
$page.MediaBox = [0, 0, 595, 842];

dies-ok { $page.MediaBox = [0, 595] }, 'MediaBox bad setter - dies';
is-json-equiv $page.MediaBox, [0, 0, 595, 842], 'MediaBox bad setter - ignored';
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 150;
my $font-size = 15;
my $x = 35;

$page.graphics: -> $gfx {

    $page.text: -> $txt {
	for <left center right> -> $align {
	    $txt.text-position = [$x, 750];
	    my $header = [~] '*** ', $align, ' ***', "\n";
	    $txt.set-font($header-font, 18);
	    $txt.say( $header, :$width, :$align);

	    my $para = q:to"--ENOUGH!!--";
	    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
	    ut labore et dolore magna aliqua.
	    --ENOUGH!!--

	    $txt.set-font($font, $font-size);
	    my $text-block = $txt.say( $para, :$width, :$align, :kern);
	    isa-ok $text-block, ::('PDF::DOM::Contents::Text::Block');
	    $x += 275;
        }

        $txt.text-position = [240, 600];
        $txt.set-font($page.core-font('ZapfDingbats'), 24);
        $txt.SetWordSpacing(16);
        my $nbsp = "\c[NO-BREAK SPACE]";
        $txt.print("♠ ♣$nbsp");
        $txt.SetFillRGB( 1, .3, .3);
	$txt.say("♦ ♥");
    }

    $page.graphics: -> $gfx {
	$gfx.SetFillRGB(0.9, 0.5, 0.0);
	$gfx.Rectangle(340, 300, 100, 100);
	$gfx.Fill;

	my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
	ok $img.Width, '$img.Width';
	$gfx.do($img, 232, 380, :width(150) );

	$gfx.block: -> $_ {
	    .SetFillRGB(0.1, 0.9, 0.5);
	    .Rectangle(90, 200, 200, 200);
	    .Fill;
	}
    }

    $page.graphics: -> $gfx {

	$gfx.transform( :translate[275, 250]);
	$gfx.transform( :rotate(-10), :scale(1.5) );
	$gfx.set-graphics( :transparency(.5) );
	$gfx.Rectangle(0, 0, 50, 50);
	$gfx.Fill;

    }

}

$page.graphics: -> $_ {
    $page.text: -> $_ {
         use PDF::DOM::Op :TextMode;
        .set-font( $header-font, 16);
        .SetTextRender: TextMode::OutlineText;
        .SetLineWidth: .5;
        .text-transform( :translate[50, 550], :slant(12) );
        .say('Outline Slanted Text @(50,550)', :width(150));
    }
}

$page.text: -> $_ {
    .text-position = [110, 300];
    .set-font( $header-font, 24);
    .say('Hello, world!');
}

my $info = $pdf.Info = {}
$info.Author = 't/helloworld.t';
$info.Creator = 'PDF::Tools';
$info.CreationDate = DateTime.new( :year(2015), :month(12), :day(25) );
skip '$pdf.Info<Author> - not completing';
##is $pdf.Info<Author>, 't/helloworld.t', '$root.Info accessor';
ok $pdf.save-as('t/helloworld.pdf'), '.save-as';
ok $pdf.save-as('t/helloworld-compressed.pdf', :compress), '.save-as( :compress )';

lives-ok {$pdf = PDF::DOM.open: 't/helloworld-compressed.pdf'}, 'pdf reload lives';
isa-ok $pdf.reader.trailer, PDF::DOM, 'trailer type';
$page = $pdf.page: 1;
isa-ok $page, ::('PDF::DOM::Type::Page'), 'first pages';
is $page.Contents.Filter, 'FlateDecode', 'page stream is compressed';
is $pdf.Info.Author, 't/helloworld.t', '$pdf.Info.Author reload';

my $contents-ast;
lives-ok {$contents-ast =  $pdf.page(1).contents-parse}, 'page contents-parse - lives';
isa-ok $contents-ast, Array, '.contents type';
ok +$contents-ast > 24, '.contents elems';
is-deeply $contents-ast[0], (:q[]), '.contents first elem';
is-deeply $contents-ast[*-1], (:ET[]), '.contents last elem';

my $gfx = $page.gfx;
is-json-equiv $gfx.ops[*-3 .. *], $( "T*" => [], :ET[], :Q[] ), '$page.gfx.ops (tail)';

lives-ok { PDF::DOM.new.save-as: "t/pdf/no-pages.pdf" }, 'create empty PDF';

done-testing;
