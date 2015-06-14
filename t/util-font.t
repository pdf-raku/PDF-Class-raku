use Test;
use v6;

use PDF::DOM::Util::Font;
use PDF::DOM;

my $hb-afm = PDF::DOM::Util::Font::core-font( 'Helvetica-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';

my $ab-afm = PDF::DOM::Util::Font::core-font( 'Arial-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';

my $hbi-afm = PDF::DOM::Util::Font::core-font( 'Helvetica-BoldItalic' );
is $hbi-afm.FontName, 'Helvetica-BoldOblique', 'FontName';

my $hb-afm-again = PDF::DOM::Util::Font::core-font( 'Helvetica-Bold' );

ok $hb-afm-again === $hb-afm, 'font caching';

my $dict = $hbi-afm.to-dom('Font');

my $font = PDF::Object.compose( :$dict );
isa-ok $font, ::('PDF::DOM::Font::Type1');
is $font.BaseFont, 'Helvetica-BoldOblique';

my $tr-afm = PDF::DOM::Util::Font::core-font( 'Times-Roman' );
is $tr-afm.stringwidth("RVX", :!kern), 2111, 'stringwidth :!kern';
is $tr-afm.stringwidth("RVX", :kern), 2111 - 80, 'stringwidth :kern';
is-deeply $tr-afm.kern("RVX" ), [:literal<R>, :num(-80), :literal<VX>], '.kern(:kern)';
is-deeply $tr-afm.kern("RVX", 12), [:literal<R>, :num(-0.96), :literal<VX>], '.kern(..., $w))';

for (win => :literal("Á®ÆØ"),
     mac => :literal("ç¨®¯")) {
    my ($enc, $expected) = .kv;
    my $fnt = PDF::DOM::Util::Font::core-font( 'helvetica', :$enc );
    my $literal = $fnt.encode( "Á®ÆØ");

    my $literal2 = $fnt.kern( "Á®ÆØ")[0];
    is-deeply $literal, $expected, "font $enc kern";
}

done;
