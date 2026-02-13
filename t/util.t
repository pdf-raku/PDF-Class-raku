use v6;
use Test;
use PDF::Class::Util :to-roman, :from-roman, :alpha-number, :decimal-number;

for (1, 'I'), (2, 'II'), (3, 'III'), (4, 'IV'), (5, 'V'), (6, 'VI'), (10, 'X'), (11, 'XI') -> @ (UInt $n, Str $r) {
    is $n.&to-roman, $r, "to-roman($n)";
    is $r.&from-roman, $n, "from-roman({$r.raku})";
}

for (1, 'A'), (2, 'B'), (26, 'Z'), (27, 'AA'), (28, 'BB') -> @ (UInt $n, Str $a) {
    is $n.&alpha-number, $a, "alpha-number($n)";
}

is 5.&decimal-number, '5', 'decimal-number';

done-testing;



