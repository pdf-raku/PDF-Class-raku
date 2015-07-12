use v6;

use PDF::DOM::Contents::Text::Atom;
use PDF::DOM::Op :OpNames;

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

    multi method align('left') {
        $.indent = 0;
    }

    multi method align('right') {
        $.indent = - $.actual-width;
    }

    multi method align('center') {
        $.indent = - $.actual-width  /  2;
    }

    method content(:$font-size) {

        my $scale = -1000 / $font-size;
        my $array = [];

        $array.push( ($.indent * $scale ).Int )
            if $.indent;

        for $.atoms.list {
            my $enc = .encoded // .content;
            $array.push( $enc)
                if $enc.chars;
            $array.push( (.space * $scale).Int )
                if .space;
        }

        $array.pop if +$array && $array[*-1] ~~ Numeric;

        (OpNames::ShowSpaceText) => [$array];

    }

}
