use v6;
use Test;
use PDF::DOM::Util::TransformMatrix;

is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(), [1, 0, 0, 1, 0, 0], 'null transform';
is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(:translate[10, 20]), [1, 0, 0, 1, 10, 20], 'translate transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(:translate(30)), [1, 0, 0, 1, 30, 30], 'translate transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(:rotate(90) ), [0, 1, -1, 0, 0, 0], 'rotate transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(:scale(1.5)), [1.5e0, 0, 0, 1.5e0, 0, 0], 'scale transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform-matrix(:scale[1.5, 2.5]), [1.5e0, 0, 0, 2.5e0, 0, 0], 'scale transform matrix';

my $skew = PDF::DOM::Util::TransformMatrix::transform-matrix( :skew(10));
is-approx $skew[1], 0.176327, 'skew transform';
is-approx $skew[2], 0.176327, 'skew transform';

$skew = PDF::DOM::Util::TransformMatrix::transform-matrix(:skew[10, 20]);
is-approx $skew[1], 0.176327, 'skew transform';
is-approx $skew[2], 0.36397, 'skew transform';

my $chained = PDF::DOM::Util::TransformMatrix::transform-matrix(
    :translate[10, 20],
    :rotate(270),
    :scale(2) );

is-deeply $chained, [0, -2, 2, 0, 40, -20], 'chained transforms';

is-deeply PDF::DOM::Util::TransformMatrix::multiply([1,2,3,4,5,6], [10,20,30,40,50,60]), [70, 100, 150, 220, 280, 400], 'multiply matrix';

my $tform = PDF::DOM::Util::TransformMatrix::transform-matrix(
    :translate[10, 20],
    :scale(2) );

is-deeply [ PDF::DOM::Util::TransformMatrix::transform($tform, 5, 15) ], [(10 + 5) * 2, (20 + 15) * 2], 'transform';
is-deeply [ PDF::DOM::Util::TransformMatrix::transform($tform, 25, 30) ], [(10 + 25) * 2, (20 + 30) * 2], 'transform';
done;
