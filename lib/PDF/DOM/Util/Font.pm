use v6;
use Font::AFM;

module PDF::DOM::Util::Font {
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

        multi method to-dom('Font') {
            { :Type( :name<Font> ), :Subtype( :name<Type1> ),
              :BaseEncoding( :name<WinAnsiEncoding> ),
              # todo /Encoding with differences between latin1 and WinsAnsiEncoding
              :BaseFont( :name( self.FontName ) ),
            }
        }

    }

    our proto sub core-font($) {*};

    multi sub core-font(Str $font-name where { stdFontMap{$font-name.lc}:exists }) {
        core-font( stdFontMap{$font-name.lc} );
    }

    multi sub core-font(Str $font-name) is default {
        state %core-font-cache;
        %core-font-cache{$font-name.lc} //= (Font::AFM.metrics-class( $font-name ) but Afm2Dom).new;
    }

}
