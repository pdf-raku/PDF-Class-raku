use v6;
use Font::AFM;

module PDF::DOM::Util::Font {
    use PDF::DOM::Util::Font::Encodings;
    # font aliases adapted from pdf.js/src/fonts.js
    BEGIN constant stdFontMap = {

        :arialnarrow<helvetica>,
        :arialnarrow-bold<helvetica-bold>,
        :arialnarrow-bolditalic<helvetica-boldoblique>,
        :arialnarrow-italic<helvetica-oblique>,

        :arialblack<helvetica>,
        :arialblack-bold<helvetica-bold>,
        :arialblack-bolditalic<helvetica-boldoblique>,
        :arialblack-italic<helvetica-oblique>,

        :arial<helvetica>,
        :arial-bold<helvetica-bold>,
        :arial-bolditalic<helvetica-boldoblique>,
        :arial-italic<helvetica-oblique>,

        :arialmt<helvetica>,
        :arial-bolditalicmt<helvetica-boldoblique>,
        :arial-boldmt<helvetica-bold>,
        :arial-italicmt<helvetica-oblique>,

        :courier-bolditalic<courier-boldoblique>,
        :courier-italic<courier-oblique>,

        :couriernew<courier>,
        :couriernew-bold<courier-bold>,
        :couriernew-bolditalic<courier-boldoblique>,
        :couriernew-italic<courier-oblique>,

        :couriernewps-bolditalicmt<courier-boldoblique>,
        :couriernewps-boldmt<courier-bold>,
        :couriernewps-italicmt<courier-oblique>,
        :couriernewpsmt<courier>,

        :helvetica-bolditalic<helvetica-boldoblique>,
        :helvetica-italic<helvetica-oblique>,

        :symbol-bold<symbol>,
        :symbol-bolditalic<symbol>,
        :symbol-italic<symbol>,

        :timesnewroman<times-roman>,
        :timesnewroman-bold<times-bold>,
        :timesnewroman-bolditalic<times-bolditalic>,
        :timesnewroman-italic<times-italic>,

        :timesnewromanps<times-roman>,
        :timesnewromanps-bold<times-bold>,
        :timesnewromanps-bolditalic<times-bolditalic>,

        :timesnewromanps-bolditalicmt<times-bolditalic>,
        :timesnewromanps-boldmt<times-bold>,
        :timesnewromanps-italic<times-italic>,
        :timesnewromanps-italicmt<times-italic>,

        :timesnewromanpsmt<times-roman>,
        :timesnewromanpsmt-bold<times-bold>,
        :timesnewromanpsmt-bolditalic<times-bolditalic>,
        :timesnewromanpsmt-italic<times-italic>,
    };

    role Afm2Dom {

        has $!glyphs;
        has $!encoding;

        method set-encoding( Str :$enc = 'win') {
            given $enc {
                when 'mac' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::mac-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::mac-encoding;
                }
                when 'win' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::win-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::win-encoding;
                }
                default { 
                    die ":enc not 'win', 'mac': $_";
                }
            }
        }

        multi method to-dom('Font') {
            { :Type( :name<Font> ), :Subtype( :name<Type1> ),
              :BaseEncoding( :name<WinAnsiEncoding> ),
              # todo /Encoding with differences between latin1 and WinsAnsiEncoding
              :BaseFont( :name( self.FontName ) ),
            }
        }

        method stringwidth($str, $pointsize=0, :$kern) {
            nextwith( $str, $pointsize, :$kern, :$!glyphs);
        }

        method kern($str, $pointsize=0) {
            my $raw = callwith( $str, $pointsize, :$!glyphs);
            [ $raw.map({
                when Numeric {:num($_)}
                default { self.encode($_) }
            }) ];
        }

        multi method encode(Str $s) {
            :literal([~] $s.comb\
                     .map({ $!glyphs{$_} })\
                     .grep({ .defined })\
                     .map({ $!encoding{$_} })\
                     .grep({ .defined }));
        }

    }

    our proto sub core-font($, :$enc?) {*};

    multi sub core-font(Str $font-name where { stdFontMap{$font-name.lc}:exists }, :$enc) {
        core-font( stdFontMap{$font-name.lc}, :$enc );
    }

    multi sub core-font(Str $font-name, :$enc is copy) is default {
        $enc //= 'win';
        state %core-font-cache;
        my $fnt = (%core-font-cache{$font-name.lc}{$enc} //= (Font::AFM.metrics-class( $font-name ) but Afm2Dom).new(:$enc));
        $fnt.set-encoding(:$enc);
        $fnt;
    }

}
