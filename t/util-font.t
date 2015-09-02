use Test;
use v6;

use PDF::DOM::Util::Font;
use PDF::DOM::Type;

my $hb-afm = PDF::DOM::Util::Font::core-font( 'Helvetica-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';
is $hb-afm.enc, 'win', '.enc';
is $hb-afm.height, 1190, 'font height';
is-approx $hb-afm.height(12), 14.28, 'font height @ 12pt';
is-approx $hb-afm.height(12, :from-baseline), 11.544, 'font base-height @ 12pt';

my $ab-afm = PDF::DOM::Util::Font::core-font( 'Arial-Bold' );
isa-ok $hb-afm, ::('Font::AFM'); 
is $hb-afm.FontName, 'Helvetica-Bold', 'FontName';

my $hbi-afm = PDF::DOM::Util::Font::core-font( :family<Helvetica>, :weight<Bold>, :style<Italic> );
is $hbi-afm.FontName, 'Helvetica-BoldOblique', ':font-family => FontName';

my $hb-afm-again = PDF::DOM::Util::Font::core-font( 'Helvetica-Bold' );

ok $hb-afm-again === $hb-afm, 'font caching';

my %params = $hbi-afm.to-dom('Font');

my $font = PDF::Object.coerce( |%params );
isa-ok $font, ::('PDF::DOM::Type::Font::Type1');
is $font.BaseFont, 'Helvetica-BoldOblique', '.BaseFont';
is $font.Encoding, 'WinAnsiEncoding', '.Encoding';
is-deeply $font.font-obj, $hbi-afm, '.font-obj';

my $tr-afm = PDF::DOM::Util::Font::core-font( 'Times-Roman' );
is $tr-afm.stringwidth("RVX", :!kern), 2111, 'stringwidth :!kern';
is $tr-afm.stringwidth("RVX", :kern), 2111 - 80, 'stringwidth :kern';
is-deeply $tr-afm.kern("RVX" ), ['R', -80, 'VX'], '.kern(...)';
is-deeply $tr-afm.kern("RVX", 12), ['R', -0.96, 'VX'], '.kern(..., $w))';

for (win => "Á®ÆØ",
     mac => "ç¨®¯") {
    my ($enc, $expected) = .kv;
    my $fnt = PDF::DOM::Util::Font::core-font( 'helvetica', :$enc );
    my $literal = $fnt.encode("Á®ÆØ");
}

my $zapf = PDF::DOM::Util::Font::core-font( 'ZapfDingbats' );
isa-ok $zapf, ::('Font::Metrics::zapfdingbats');
is $zapf.enc, 'zapf', '.enc';
is $zapf.encode("♥♣✔").join, "ª¨4", '.encode(...)'; # /a110 /a112 /a20

%params = $zapf.to-dom('Font');

my $zapf-font = PDF::Object.coerce( |%params );
isa-ok $zapf-font, ::('PDF::DOM::Type::Font::Type1');
is $zapf-font.BaseFont, 'ZapfDingbats', '.BaseFont';
ok !$zapf-font.Encoding.defined, '!.Encoding';

my $sym = PDF::DOM::Util::Font::core-font( 'Symbol' );
isa-ok $sym, ::('Font::Metrics::symbol');
is $sym.enc, 'sym', '.enc';
is $sym.encode("ΑΒΓ").join, "ABG", '.encode(...)'; # /Alpha /Beta /Gamma

%params = $sym.to-dom('Font');

my $sym-font = PDF::Object.coerce( |%params );
isa-ok $sym-font, ::('PDF::DOM::Type::Font::Type1');
is $sym-font.BaseFont, 'Symbol', '.BaseFont';
ok !$sym-font.Encoding.defined, '!.Encoding';
is $sym-font.encode("ΑΒΓ").join, "ABG", '.encode(...)'; # /Alpha /Beta /Gamma

done-testing;
