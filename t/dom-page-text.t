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

my $dom = PDF::DOM.new;
$dom.Pages.add-page: $page;
$dom.save-as('t/dom-page-text.pdf');

done;
