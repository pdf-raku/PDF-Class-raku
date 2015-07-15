use v6;

use PDF::DOM::Contents::Text::Atom;
use PDF::DOM::Op :OpNames;

class PDF::DOM::Contents::Text::Line {

    has @.atoms;
    has Numeric $.indent is rw = 0;

    method actual-width returns Numeric { [+] @!atoms.map({ .width + .space }) };

    multi method align('justify', Numeric :$width! ) {
        my Numeric $actual-width = $.actual-width;

        if $width > $actual-width {
            # stretch both word boundaries and non-breaking spaces
            my @elastics = @!atoms.grep({ .elastic });

            if +@elastics {
                my Numeric $stretch = ($width - $actual-width) / +@elastics;
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

    method content(Numeric :$font-size!, Numeric :$space-size!, Numeric :$word-spacing = 0) {

        my Numeric $scale = -1000 / $font-size;
        my Array $array = [];

        $array.push( ($.indent * $scale ).round.Int )
            if $.indent;

        for $.atoms.list {
	    my Numeric $space = .space;
	    $space += $word-spacing
		if $space > 0 && $word-spacing;
	    $space = ($space * $scale).round.Int;
            my Str $enc = .encoded // .content;

	    if $space && $space-size && abs($space - $space-size) <= 1 {
		# optimization: use an actual space, when it fits
		$enc ~= ' ';
		$space = 0;
	    }

	    if $enc.chars {
		if $array && $array[*-1] ~~ Str {
		    # on a string segment - concatonate
		    $array[*-1] ~= $enc
		}
		else {
		    # start a new string segment
		    $array.push( $enc);
		}
	    }

            $array.push( $space )
                if $space;
        }

        $array.pop if +$array && $array[*-1] ~~ Numeric;

        (OpNames::ShowSpaceText) => [$array];

    }

}
