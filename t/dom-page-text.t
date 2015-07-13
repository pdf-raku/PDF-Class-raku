use v6;
use Test;
use PDF::DOM;
use PDF::DOM::Type::Page;
use PDF::DOM::Op :OpNames;

my $page = PDF::DOM::Type::Page.new;
my $gfx = $page.gfx;
my $font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $width = 50;
my $font-size = 18;

$gfx.op(BeginText);
$gfx.text-move(50,100);
$gfx.set-font($font, $font-size);
$gfx.say('Hello, World!', :$width, :kern);
$gfx.op(EndText);

is-deeply [$gfx.content.lines], [
    "BT",
    "50 100 Td", 
    "/F1 18 Tf",
    "19.8 TL",
    "[ (Hello,) ] TJ",
    "T*",
    "[ (W) 60 (orld!) ] TJ",
    "T*",
    "ET"];

$width = 100;
my $height = 80;
my $x = 110;

$gfx.op(BeginText);
$gfx.set-font( $page.core-font( :family<Helvetica> ), 10);

for <text top center bottom> -> $valign {

    my $y = 700;

    for <left center right justify> -> $align {
        my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua.
        --ENOUGH!!--

        $gfx.text-move($x, $y, :abs);
        my $text-block = $gfx.say( "*** $valign $align*** " ~ $body, :$width, :$height, :$valign, :$align);
        $y -= 170;
    }

   $x += 125;
}
$gfx.op(EndText);

my $dom = PDF::DOM.new;
$dom.Pages.add-page: $page;
$dom.save-as('t/dom-page-text.pdf');

done;
