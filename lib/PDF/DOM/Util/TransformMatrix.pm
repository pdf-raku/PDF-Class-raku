use v6;

module PDF::DOM::Util::TransformMatrix {

    # Designed to work on PDF text and graphics transformation matrices of the form:
    #
    # [ a b 0 ]
    # [ c d 0 ]
    # [ e f 1 ]
    #
    # where a b c d e f are stored in a six digit array and the third column is implied.

    sub deg2rad (Numeric $deg) {
        return $deg * pi / 180;
    }

    subset TransformMatrix of Array where {.elems == 6}

    sub identity {
        [1, 0, 0, 1, 0, 0];
    }

    sub translate(Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [1, 0, 0, 1, $x, $y];
    }

    sub rotate( Numeric $deg! --> TransformMatrix) {
        my $r = deg2rad($deg);
        my $cos = cos($r);
        my $sin = sin($r);

        [$cos, $sin,-$sin, $cos, 0, 0];
    }

    sub scale(Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [$x, 0, 0, $y, 0, 0];
    }

    sub skew(Numeric $x, Numeric $y = $x --> TransformMatrix) {
        [1, tan(deg2rad($x)), tan(deg2rad($y)), 1, 0, 0];
    }

    our sub multiply(TransformMatrix $a!, TransformMatrix $b! --> TransformMatrix) {

        [ $b[0]*$a[0] + $b[2]*$a[1],
          $b[1]*$a[0] + $b[3]*$a[1],
          $b[0]*$a[2] + $b[2]*$a[3],
          $b[1]*$a[2] + $b[3]*$a[3],
          $b[0]*$a[4] + $b[2]*$a[5] + $b[4],
          $b[1]*$a[4] + $b[3]*$a[5] + $b[5],
        ];
    }

    our sub apply(TransformMatrix $a! is rw, TransformMatrix $b! --> TransformMatrix) {
	$a = multiply($a, $b);
    }

    our sub round(Numeric $n) {
	my $r = $n.round(1e-6);
	my $i = $n.round;
	constant Epsilon = 1e-5;
	abs($n - $i) < Epsilon
	    ?? $i.Int   # assume it's an int
	    !! $r;
    }

    multi sub vect(Numeric $n!) {($n, $n)}
    multi sub vect(Array $v where {+$v == 2}) {$v.flat}

    our sub transform(
	:$translate,
	:$rotate?,
	:$scale?,
	:$skew?,
	:$matrix?,
	) {
	my $t = identity();
	apply($t, translate( |@( vect($translate) ) )) if $translate.defined;
	apply($t, rotate( $rotate ))                   if $rotate.defined;
	apply($t, scale( |@( vect($scale) ) ))         if $scale.defined;
	apply($t, skew( |@( vect($skew) ) ))           if $skew.defined;
	apply($t, $matrix) if $matrix.defined;
	[ $t.map({ round($_) }) ];
    }


}
