use v6;
use Test;
use PDF::DOM::Util::TransformMatrix;

sub rounded(Array $a) {
    [ $a.map({ + sprintf("%.2f", $_) }) ]
}

is-deeply PDF::DOM::Util::TransformMatrix::transform('identity'), [1, 0, 0, 1, 0, 0], 'identify transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform('translate', 10, 20), [1, 0, 0, 1, 10, 20], 'translate transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform('translate', 30), [1, 0, 0, 1, 30, 30], 'translate transform matrix';
is-deeply rounded(PDF::DOM::Util::TransformMatrix::transform('rotate', 90)), [0.0, 1.0, -1.0, 0.0, 0.0, 0.0], 'rotate transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform('scale', 1.5), [1.5, 0, 0, 1.5, 0, 0], 'scale transform matrix';
is-deeply PDF::DOM::Util::TransformMatrix::transform('scale', 1.5, 2.5), [1.5, 0, 0, 2.5, 0, 0], 'scale transform matrix';
is-deeply rounded(PDF::DOM::Util::TransformMatrix::transform('skew', 10)), [1.0, 0.18, 0.18, 1.0, 0.0, 0.0], 'skew transform matrix';
is-deeply rounded(PDF::DOM::Util::TransformMatrix::transform('skew', 10, 20)), [1.0, 0.18, 0.36, 1.0, 0.0, 0.0], 'skew transform matrix';

is-deeply PDF::DOM::Util::TransformMatrix::multiply([1,2,3,4,5,6], [10,20,30,40,50,60]), [70, 100, 150, 220, 280, 400], 'multiply matrix';
done;
