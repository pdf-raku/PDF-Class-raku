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

    method content(Numeric :$font-size, Numeric :$space-size) {

        my $scale = -1000 / $font-size;
        my $array = [];

        $array.push( ($.indent * $scale ).Int )
            if $.indent;

        for $.atoms.list {
	    my $space = (.space * $scale).Int;
            my $enc = .encoded // .content;

	    if $space && $space-size && $space == $space-size {
		# optimization convert a spacing of ' ' to a ' '
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
