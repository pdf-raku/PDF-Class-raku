use v6;

use PDF::DOM::Contents::Text::Atom;

class PDF::DOM::Contents::Text::Line {

    has @.atoms;
    has Numeric $.indent is rw = 0;

    method actual-width  { [+] @!atoms.map({ .width + .space }) };

    multi method align('justify', Numeric :$width! ) {
        my $actual-width = $.actual-width;

        if $width > $actual-width {
            # stretch both word boundaries and non-breaking spaces
            my @elastics = @!atoms.grep({ .elastic });

            if +@elastics {
                my $stretch = ($width - $actual-width) / +@elastics;
                .space += $stretch
                    for @elastics;
            }

            $.indent = 0;
        }
    }

    multi method align('left', Numeric :$width! ) {
        $.indent = 0;
    }

    multi method align('right', Numeric :$width! ) {
        $.indent = $width - $.actual-width;
    }

    multi method align('center', Numeric :$width! ) {
        $.indent = ( $width - $.actual-width )  /  2;
    }

    method content(:$font-size) {

        my $scale = -1000 / $font-size;

        my @array = $.atoms.map({
            ( :literal(.encoded // .content), :int( (.space * $scale).Int ) )
        });
        @array.pop;

        @array.unshift: (:int( ( $.indent * $scale ).Int ) )
            if $.indent;

        :TJ(:@array);

    }

}
