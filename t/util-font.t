use Test;
use v6;

use PDF::Doc::Util::Font;
use PDF::Doc::Type;

my $hb-afm = PDF::Doc::Util::Font::core-font( 'Helvetica-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';
is $hb-afm.enc, 'win', '.enc';
is $hb-afm.height, 1190, 'font height';
is-approx $hb-afm.height(12), 14.28, 'font height @ 12pt';
is-approx $hb-afm.height(12, :from-baseline), 11.544, 'font base-height @ 12pt';

my $ab-afm = PDF::Doc::Util::Font::core-font( 'Arial-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';

my $hbi-afm = PDF::Doc::Util::Font::core-font( :family<Helvetica>, :weight<Bold>, :style<Italic> );
is $hbi-afm.FontName, 'Helvetica-BoldOblique', ':font-family => FontName';

my $hb-afm-again = PDF::Doc::Util::Font::core-font( 'Helvetica-Bold' );

ok $hb-afm-again === $hb-afm, 'font caching';

my $tr-afm = PDF::Doc::Util::Font::core-font( 'Times-Roman' );
is $tr-afm.stringwidth("RVX", :!kern), 2111, 'stringwidth :!kern';
is $tr-afm.stringwidth("RVX", :kern), 2111 - 80, 'stringwidth :kern';
is-deeply $tr-afm.kern("RVX" ), ['R', -80, 'VX'], '.kern(...)';
is-deeply $tr-afm.kern("RVX", 12), ['R', -0.96, 'VX'], '.kern(..., $w))';

for (win => "Á®ÆØ",
     mac => "ç¨®¯") {
    my ($enc, $expected) = .kv;
    my $fnt = PDF::Doc::Util::Font::core-font( 'helvetica', :$enc );
    my $literal = $fnt.encode("Á®ÆØ");
}

my $zapf = PDF::Doc::Util::Font::core-font( 'ZapfDingbats' );
isa-ok $zapf, ::('Font::Metrics::zapfdingbats');
is $zapf.enc, 'zapf', '.enc';
is $zapf.encode("♥♣✔").join, "ª¨4", '.encode(...)'; # /a110 /a112 /a20

my $sym = PDF::Doc::Util::Font::core-font( 'Symbol' );
isa-ok $sym, ::('Font::Metrics::symbol');
is $sym.enc, 'sym', '.enc';
is $sym.encode("ΑΒΓ").join, "ABG", '.encode(...)'; # /Alpha /Beta /Gamma

done-testing;
