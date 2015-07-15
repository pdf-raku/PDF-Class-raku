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

        :times<times-roman>,
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

        has $.enc;
        has $!glyphs;
        has $!encoding;

        method set-encoding( Str :$!enc = 'win') {
            given $!enc {
                when 'mac' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::mac-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::mac-encoding;
                }
                when 'win' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::win-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::win-encoding;
                }
                when 'sym' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::sym-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::sym-encoding;
                }
                when 'zapf' {
                    $!glyphs = $PDF::DOM::Util::Font::Encodings::zapf-glyphs;
                    $!encoding = $PDF::DOM::Util::Font::Encodings::zapf-encoding;
                }
                default { 
                    die ":enc not 'win', 'mac'. 'sym' or 'zapf': $_";
                }
            }
        }

        #| compute the overall font-height
        method height($pointsize?, Bool :$from-baseline = False) {
            my $bbox = $.FontBBox;
            my $height = $bbox[3];
            $height -= $bbox[1] unless $from-baseline;
            $pointsize ?? $height * $pointsize / 1000 !! $height;
        }

	#| reduce string to the displayable characters
        method filter(Str $text-in) {
	    $text-in.comb.grep({ $!glyphs{$_}:exists }).join: '';
	}

	#| map ourselves to a PDF::DOM object
        method to-dom('Font') {
            my %enc-name = :win<WinAnsiEncoding>, :mac<MacRomanEncoding>;
            my $dict = { :Type( :name<Font> ), :Subtype( :name<Type1> ),
                        :BaseFont( :name( self.FontName ) ),
            };

            if my $name = %enc-name{self.enc} {
                $dict<Encoding> = :$name;
            }

            %( :$dict, :font-obj(self) )
        }

        method stringwidth(Str $str, Numeric $pointsize=0, Bool :$kern=False) {
            nextwith( $str, $pointsize, :$kern, :$!glyphs);
        }

        multi method encode(Str $s) {
            $s.comb\
                .map({ $!glyphs{$_} })\
                .grep({ .defined })\
                .map({ $!encoding{$_} })\
                .grep({ .defined });
        }

    }

    our proto sub core-font(|c) {*};

    multi sub core-font( Str :$family!, Str :$weight?, Str :$style?, :$enc) {

        my $bold = $weight && $weight ~~ m:i/bold|[6..9]00/
            ?? 'bold' !! '';

        # italic & oblique can be treated as synonyms for core fonts
        my $italic = $style && $style ~~ m:i/italic|oblique/
            ?? 'italic' !! '';

        my $sfx = $bold || $italic
            ?? '-' ~ $bold ~ $italic
            !! '';

        my $font-name = $family.subst(/['-'.*]? $/, $sfx );

        core-font( $font-name, :$enc );
    }

    sub load-font($font-name, :$enc!) {
        state %core-font-cache;
        my $fnt = (%core-font-cache{$font-name.lc}{$enc} //= (Font::AFM.metrics-class( $font-name ) but Afm2Dom).new(:$enc));
        $fnt.set-encoding(:$enc);
        $fnt;
    }

    multi sub core-font(Str $font-name! where { $font-name ~~ m:i/^ ZapfDingbats $/ }) {
        load-font( $font-name.lc, :enc<zapf> );
    }

    multi sub core-font(Str $font-name! where { $font-name ~~ m:i/^ Symbol $/ }) {
        load-font( $font-name.lc, :enc<sym> );
    }

    multi sub core-font(Str $font-name! where { stdFontMap{$font-name.lc}:exists }, :$enc) {
        core-font( stdFontMap{$font-name.lc}, :$enc );
    }

    multi sub core-font(Str $font-name!, :$enc is copy) is default {
        $enc //= 'win';
        load-font( $font-name.lc, :$enc );
    }

}
