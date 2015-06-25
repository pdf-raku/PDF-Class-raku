use v6;
use Test;
use PDF::DOM::Type::Page;

my $page = PDF::DOM::Type::Page.new;
my $gfx = $page.gfx;
my $font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $width = 50;
my $font-size = 18;

$gfx.text('Hello, World!', :$font, :$font-size, :$width, :kern);

is-deeply [$gfx.content.lines], [
    "/F1 18 Tf",
    "19.8 TL",
    "[ (Hello,) ] TJ",
    "T*",
    "[ (W) 60 (orld!) ] TJ",
    "T*",];

done;
