use v6;
use Test;

use PDF::DOM;
use PDF::DOM::Contents::Op :OpNames;
my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
my $gfx = $page.gfx;
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 150;
my $font-size = 15;
my $x = 35;

for <left center right> -> $align {
    $gfx.text-move($x, 750, :abs);
    my $header = [~] '*** ', $align, ' ***', "\n";
    $gfx.say( $header, :font($header-font), :font-size(18), :$width, :$align);

    my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua.
        --ENOUGH!!--

    my $text-block = $gfx.say( $body, :$font, :$font-size, :$width, :$align, :kern);
    isa-ok $text-block, ::('PDF::DOM::Contents::Text::Block');
    $x += 275;
}

$gfx.block: {
    $gfx.text-move(240,600, :abs);
    $gfx.set-font($page.core-font('ZapfDingbats'), 24);
    $gfx.op(SetWordSpacing, 16);
    my $nbsp = "\c[NO-BREAK SPACE]";
    $gfx.print("♠ ♣$nbsp");
    $gfx.op(SetFillRGB, 1, .3, .3);
    $gfx.say("♦ ♥");
};

my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
ok $img.Width, '$img.Width';
$gfx.do($img, 232, 380, :width(150) );

$gfx.text-move(100,300, :abs);
$gfx.say('Hello, world!', :font($header-font), :font-size(24));

ok $pdf.save-as('t/helloworld.pdf'), '.save-as';
ok $pdf.save-as('t/helloworld-compressed.pdf', :compress), '.save-as( :compress )';

done;
