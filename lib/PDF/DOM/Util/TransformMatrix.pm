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

    our proto sub transform(|c) {*};
    our proto sub multiply(|c) {*};

    multi sub transform('identity') {
        [1, 0, 0, 1, 0, 0];
    }

    multi sub transform('translate', Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [1, 0, 0, 1, $x, $y];
    }

    multi sub transform('rotate', Numeric $deg! --> TransformMatrix) {
        my $r = deg2rad($deg);
        my $cos = cos($r);
        my $sin = sin($r);

        [$cos, $sin,-$sin, $cos, 0, 0];
    }

    multi sub transform('scale', Numeric $x!, Numeric $y = $x --> TransformMatrix) {
        [$x, 0, 0, $y, 0, 0];
    }

    multi sub transform('skew', Numeric $x, Numeric $y = $x --> TransformMatrix) {
        [1, tan(deg2rad($x)), tan(deg2rad($y)), 1, 0, 0];
    }

    multi sub multiply(TransformMatrix $a!, TransformMatrix $b! --> TransformMatrix) {

        [ $b[0]*$a[0] + $b[2]*$a[1],
          $b[1]*$a[0] + $b[3]*$a[1],
          $b[0]*$a[2] + $b[2]*$a[3],
          $b[1]*$a[2] + $b[3]*$a[3],
          $b[0]*$a[4] + $b[2]*$a[5] + $b[4],
          $b[1]*$a[4] + $b[3]*$a[5] + $b[5],
        ];
    }
}
