use v6;

module PDF::DOM::Util::TransformMatrix {

    # Designed to work on PDF text and graphics transformation matrices of the form:
    #
    # [ a b 0 ]
    # [ c d 0 ]
    # [ e f 1 ]
    #
    # where a b c d e f are stored in a six digit array and the third column is implied.

    my Int enum Abcdefg « :a(0) :b(1) :c(2) :d(3) :e(4) :f(5) »;

    sub deg2rad (Numeric $deg) {
        return $deg * pi / 180;
    }

    subset TransformMatrix of Array where {.elems == 6}

    sub identity returns TransformMatrix {
        [1, 0, 0, 1, 0, 0];
    }

    sub translate(Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [1, 0, 0, 1, $x, $y];
    }

    sub rotate( Numeric $deg! --> TransformMatrix) {
        my Numeric $r = deg2rad($deg);
        my Numeric $cos = cos($r);
        my Numeric $sin = sin($r);

        [$cos, $sin,-$sin, $cos, 0, 0];
    }

    sub scale(Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [$x, 0, 0, $y, 0, 0];
    }

    sub skew(Numeric $x, Numeric $y = $x --> TransformMatrix) {
        [1, tan(deg2rad($x)), tan(deg2rad($y)), 1, 0, 0];
    }

    #| multiply transform matrix $a X $b
    our sub multiply(TransformMatrix $a!, TransformMatrix $b! --> TransformMatrix) {

        [ $b[a]*$a[a] + $b[c]*$a[b],
          $b[b]*$a[a] + $b[d]*$a[b],
          $b[a]*$a[c] + $b[c]*$a[d],
          $b[b]*$a[c] + $b[d]*$a[d],
          $b[a]*$a[e] + $b[c]*$a[f] + $b[e],
          $b[b]*$a[e] + $b[d]*$a[f] + $b[f],
        ];
    }

    #| Coordinate transfrom of x, y: See [PDF 1.7 Sectiono 4.2.3 Transformation Matrices]
    #|  x' = a.x  + c.y + e; y' = b.x + d.y +f
    our sub transform(TransformMatrix $tm!, Numeric $x, Numeric $y) {
	($tm[a]*$x + $tm[c]*$y + $tm[e],
	 $tm[b]*$x + $tm[d]*$y + $tm[f])
    }

    #| Compute: $a = $a X $b
    our sub apply(TransformMatrix $a! is rw, TransformMatrix $b! --> TransformMatrix) {
	$a = multiply($a, $b);
    }

    our sub round(Numeric $n) {
	my Numeric $r = $n.round(1e-6);
	my Int $i = $n.round;
	constant Epsilon = 1e-5;
	abs($n - $i) < Epsilon
	    ?? $i.Int   # assume it's an int
	    !! $r;
    }

    multi sub vect(Numeric $n! --> List) {@($n, $n)}
    multi sub vect(Array $v where {+$v == 2} --> List) {@$v}

    #| 3 [PDF 1.7 Section 4.2.2 Common Transforms
    #| order of transforms is: 1. Translate  2. Rotate 3. Scale/Skew

    our sub transform-matrix(
	Numeric :$slant,
	:$translate,
	:$rotate,
	:$scale,
	:$skew,
	:$matrix,
	--> TransformMatrix
	) {
	my TransformMatrix $t = identity();
	apply($t, skew( 0, $slant) )                   if $slant;
	apply($t, translate( |@( vect($translate) ) )) if $translate.defined;
	apply($t, rotate( $rotate ))                   if $rotate.defined;
	apply($t, scale( |@( vect($scale) ) ))         if $scale.defined;
	apply($t, skew( |@( vect($skew) ) ))           if $skew.defined;
	apply($t, $matrix) if $matrix.defined;
	[ $t.map({ round($_) }) ];
    }


}
