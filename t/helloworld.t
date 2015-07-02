use v6;
use Test;

use PDF::DOM;
my $pdf = PDF::DOM.new;
my $page = $pdf.Pages.add-page;
my $gfx = $page.gfx;
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 150;
my $font-size = 15;
my $x = 35;

for <left center right> -> $align {
    $gfx.text-move($x, 750, :abs);
    my $header = [~] '*** ', $align, ' ***', "\n";
    my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua.
        --ENOUGH!!--

    $gfx.text( $header, :font($header-font), :font-size(18), :$width, :$align);
    my $text-block = $gfx.text( $body, :$font, :$font-size, :$width, :$align, :kern);
    isa-ok $text-block, ::('PDF::DOM::Contents::Text::Block');
    $gfx.ops.push: 'T*';
    $gfx.restore;
    $x += 200;
}

$gfx.save;
$gfx.op('rg', 1, .3, .3);
$gfx.text-move(272,600, :abs);
$gfx.text("♠♥♦♣", :font($page.core-font('ZapfDingbats')), :font-size(24), :$width );
$gfx.restore;

my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
ok $img.Width, '$img.Width';
$gfx.do($img, 232, 380, :width(150) );

$gfx.text-move(100,300, :abs);
$gfx.text('Hello, world!', :font($header-font), :font-size(24));

ok $pdf.save-as('t/helloworld.pdf'), '.save-as';
ok $pdf.save-as('t/helloworld-compressed.pdf', :compress), '.save-as( :compress )';

done;
