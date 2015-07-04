use v6;
use Test;
use PDF::DOM;
use PDF::DOM::Type::Page;

my $page = PDF::DOM::Type::Page.new;
my $gfx = $page.gfx;
my $font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $width = 50;
my $font-size = 18;

$gfx.text-move(50,100);
$gfx.say('Hello, World!', :$font, :$font-size, :$width, :kern);

is-deeply [$gfx.content.lines], [
    "50 100 Td", 
    "/F1 18 Tf",
    "19.8 TL",
    "[ (Hello,) ] TJ",
    "T*",
    "[ (W) 60 (orld!) ] TJ",
    "T*",];

$font = $page.core-font( :family<Helvetica> );
$font-size = 10;
$width = 100;
my $height = 80;
my $x = 110;

for <none top center bottom> -> $valign {

    my $y = 700;

    for <left center right justify> -> $align {
        my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua.
        --ENOUGH!!--

        $gfx.text-move($x, $y, :abs);
        my $text-block = $gfx.say( "*** $valign $align*** " ~ $body, :$font, :$font-size, :$width, :$height, :$valign, :$align);
        $y -= 170;
    }

   $x += 125;
}


my $dom = PDF::DOM.new;
$dom.Pages.add-page: $page;
$dom.save-as('t/dom-page-text.pdf');

done;
