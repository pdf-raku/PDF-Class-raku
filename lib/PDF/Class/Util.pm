unit module PDF::Class::Util;

constant %Roman-Numerals = %( :M(1000), :CM(900), :D(500), :CD(400), :C(100), :XC(90), :L(50), :XL(40) :X(10), :IX(9), :V(5), :IV(4), :I(1) );
constant @To-Roman = [ %Roman-Numerals.invert.sort.reverse ];
our proto sub roman-numerals($, :$lc?) is export(:roman-numerals) {*}
multi sub roman-numerals($_, :$lc! where .so) {
    roman-numerals($_).lc
}
multi sub roman-numerals(0) { '' }
multi sub roman-numerals(UInt \n) is default {
    given @To-Roman.first({n >= .key}) {
        .value ~ roman-numerals(n - .key);
    }
}

our proto sub alpha-number($, :$lc?) is export(:alpha-number) {*}
multi sub alpha-number($_, :$lc! where .so) {
    alpha-number($_).lc
}
multi sub alpha-number(UInt \n) is default {
    my \m = (n - 1) mod 26;
    my \repeats = n div 26 + 1;
    ('A'.ord + m).chr;
}

sub decimal-number(UInt $_) is export(:decimal-number) {
    .Int.Str
}
