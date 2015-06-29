use v6;

role PDF::DOM::Contents::Op {
    multi method op(Str $op! where 'BT' | 'ET' | 'EMC' | 'BI' | 'ID' | 'EI' | 'BX' | 'EX' | 'b*' | 'b' | 'B*' | 'B'
                                  | 'f*' | 'F' | 'f' | 'h' | 'n' | 'q' | 'Q' | 's' | 'S' | 'T*' | 'W*' | 'W' ) {
        $op
    }
    multi method op(Str $op! where 'BMC' | 'BDC' | 'cs' | 'CS' | 'Do' | 'DP' | 'gs' | 'ri' | 'sh',
        Str $name!) {
        $op => [ :$name ],
    }
    multi method op(Str $op! where 'Tj' | "'",
        Str $literal!) {
        $op => [ :$literal ],
    }
    multi method op(Str $op! where 'TJ',
        Array $array!) {
        $op => [ :$array ]
    }
    multi method op(Str $op! where 'Tf',
        Str $name!, Numeric $real!) {
        $op => [ :$name, :$real ]
    }
    multi method op(Str $op! where 'BDC' | 'DP',
        Str $name!, Hash $dict!) {
        $op => [ :$name, :$dict ]
    }
    multi method op(Str $op! where 'd' | 'i' | 'g' | 'G' | 'M' | 'MP' | 'Tc' | 'TL' | 'Ts' | 'Tw' | 'Tz' | 'w',
        Numeric $real!) {
        $op => [ :$real ]
    }
    multi method op(Str $op! where 'j' | 'J' | 'Tr',
        Int $int!) {
        $op => [ :$int ]
    }
    multi method op(Str $op! where 'd0' | 'l' | 'm' | 'Td' | 'TD',
        Numeric $n1!, Numeric $n2!) {
        $op => [ :real($n1), :real($n2) ]
    }
    multi method op(Str $op! where '"',
        Numeric $n1!, Numeric $n2!, Str $literal! ) {
        $op => [ :real($n1), :real($n2), :$literal ]
    }
    multi method op(Str $op! where 'rg' | 'RG',
        Numeric $n1!, Numeric $n2!, Numeric $n3!) {
        $op => [ :real($n1), :real($n2), :real($n3) ]
    }
    multi method op(Str $op! where 'k' | 'K' | 're' | 'SC' | 'sc' | 'v' | 'y',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4) ]
    }
    multi method op(Str $op! where 'c' | 'd1' | 'Tm',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!, Numeric $n5!, Numeric $n6!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4), :real($n5), :real($n6) ]
    }
    multi method op(Str $op! where 'scn' | 'SCN', *@args is copy) {

        # scn & SCN have an optional trailing name
        my $name = @args.pop
            if +@args && @args[*-1] ~~ Str;

        die "too few arguments to: $op"
            unless $name.defined || @args;

        @args = @args.map({ die "$op: bad argument: {.perl}" unless $_ ~~ Numeric;
                            :real($_) });

        @args.push: (:$name) if $name.defined;

        $op => [ @args ]
    }
    multi method op(Str $op!, *@args) {
        die "bad operation: $op @args[]";
    }
    multi method op(Pair $op!) {
        self.op($op.key, |@($op.value.list) );
    }
    multi method op(Array $op!) {
        $op.list.map({self.op($_)});
    }
    multi method op(*@args) is default {
        die "unknown op: @args[]";
    }
}
