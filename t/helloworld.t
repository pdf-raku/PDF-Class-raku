use v6;
use Test;

use PDF::DOM;
use PDF::DOM::Op :OpNames;
my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
my $gfx = $page.gfx;
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 150;
my $font-size = 15;
my $x = 35;

$gfx.BeginText;

for <left center right> -> $align {
    $gfx.text-move($x, 750, :abs);
    my $header = [~] '*** ', $align, ' ***', "\n";
    $gfx.set-font($header-font, 18);
    $gfx.say( $header, :$width, :$align);

    my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua.
        --ENOUGH!!--

    $gfx.set-font($font, $font-size);
    my $text-block = $gfx.say( $body, :$font, :$font-size, :$width, :$align, :kern);
    isa-ok $text-block, ::('PDF::DOM::Contents::Text::Block');
    $x += 275;
}

$gfx.block: {
    $gfx.text-move(240,600, :abs);
    $gfx.set-font($page.core-font('ZapfDingbats'), 24);
    $gfx.SetWordSpacing(16);
    my $nbsp = "\c[NO-BREAK SPACE]";
    $gfx.print("♠ ♣$nbsp");
    $gfx.SetFillRGB( 1, .3, .3);
    $gfx.say("♦ ♥");
};

$gfx.block: {
    $gfx.SetFillRGB(0.9, 0.5, 0.0);
    $gfx.Rectangle(350, 300, 100, 100);
    $gfx.Fill;
    $gfx.block: {
	$gfx.SetFillRGB(0.1, 0.9, 0.5);
	$gfx.Rectangle(100, 200, 200, 200);
	$gfx.Fill;
    }
}

$gfx.block: {
    $gfx.transform( :translate[285, 250]);
    $gfx.transform( :rotate(-10), :scale(1.5) );
    $gfx.set-graphics( :transparency(.5) );
    $gfx.Rectangle(0, 0, 50, 50);
    $gfx.Fill;
}

my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
ok $img.Width, '$img.Width';
$gfx.do($img, 232, 380, :width(150) );

$gfx.text-move(100,300, :abs);
$gfx.set-font( $header-font, 24);
$gfx.say('Hello, world!');
$gfx.EndText;

$pdf<Info><Author> = 't/helloworld.t';
$pdf<Info><Creator> = 'PDF::Tools';
is $pdf.Info<Author>, 't/helloworld.t', '$root.Info accessor';
ok $pdf.save-as('t/helloworld.pdf'), '.save-as';
ok $pdf.save-as('t/helloworld-compressed.pdf', :compress), '.save-as( :compress )';

lives-ok {$pdf = PDF::DOM.open: 't/helloworld-compressed.pdf'}, 'pdf reload lives';

isa-ok $pdf.page(1), ::('PDF::DOM::Type::Page'), 'first pages';
is $pdf.page(1).Contents.Filter, 'FlateDecode', 'page stream is compressed';

my $contents-ast;
lives-ok {$contents-ast =  $pdf.page(1).contents-parse}, 'page contents-parse - lives';
isa-ok $contents-ast, Array, '.contents type';
ok +$contents-ast > 24, '.contents elems';
is-deeply $contents-ast[0], (:BT[]), '.contents first elem';
is-deeply $contents-ast[*-1], (:ET[]), '.contents last elem';

done;
