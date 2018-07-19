unit module PDF::Class::Util;

constant %Roman-Numerals = %( :M(1000), :CM(900), :D(500), :CD(400), :C(100), :XC(90), :L(50), :XL(40) :X(10), :IX(9), :V(5), :IV(4), :I(1) );
constant @To-Roman = [ %Roman-Numerals.invert.sort.reverse ];
our proto sub to-roman($, :$lc?) is export(:to-roman) {*}
multi sub to-roman($_, :$lc! where .so) {
    to-roman($_).lc
}
multi sub to-roman(0) { '' }
multi sub to-roman(UInt \n) is default {
    given @To-Roman.first({n >= .key}) {
        .value ~ to-roman(n - .key);
    }
}

sub from-roman(Str \r) is export(:from-roman) {
    my Str @r = r.uc.comb;
    my $num = 0;
    while @r {
        if @r >= 2 && my $d = %Roman-Numerals{@r[0] ~ @r[1]} {
            $num += $d;
            @r.pop;
        }
        else {
            $num += $_
                with %%Roman-Numerals{@r[0]};
        }
        @r.pop;
    }
    $num;
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
