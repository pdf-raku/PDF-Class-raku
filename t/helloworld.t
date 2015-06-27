use v6;
use Test;

use PDF::DOM;

my $pdf = PDF::DOM.new;
my $page = $pdf.Pages.add-page;
my $gfx = $page.gfx;
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 300;
my $font-size = 15;

$gfx.text-move(50, 750);

for <left center right justify> -> $align {
    my $header = [~] '*** ALIGN:', "\c[NO-BREAK SPACE]", $align, ' ***', "\n";
    my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
        laboris nisi ut aliquip ex ea commodo consequat.
        --ENOUGH!!--

    note "% **** $align *** ";
    $gfx.text( $header, :font($header-font), :font-size(18), :$width, :$align);
    my $text-block = $gfx.text( $body, :$font, :$font-size, :$width, :$align, :kern);
    isa-ok $text-block, ::('PDF::DOM::Contents::Text::Block');
    $gfx.ops.push: 'T*';

}

ok $pdf.save-as('t/helloworld.pdf'), '.save-as';

done;
