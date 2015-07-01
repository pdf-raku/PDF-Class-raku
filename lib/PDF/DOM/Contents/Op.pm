use v6;

use PDF::Writer;
use PDF::Object :from-ast;

role PDF::DOM::Contents::Op {

    has @!ops;

    multi sub op(Str $op! where 'BT' | 'ET' | 'EMC' | 'BI' | 'ID' | 'EI' | 'BX' | 'EX' | 'b*' | 'b' | 'B*' | 'B'
                                  | 'f*' | 'F' | 'f' | 'h' | 'n' | 'q' | 'Q' | 's' | 'S' | 'T*' | 'W*' | 'W') {
        $op;
    }
    multi sub op(Str $op! where 'BMC' | 'BDC' | 'cs' | 'CS' | 'Do' | 'DP' | 'gs' | 'ri' | 'sh',
        Str $name!) {
        $op => [ :$name ]
    }
    multi sub op(Str $op! where 'Tj' | "'",
        Str $literal!) {
        $op => [ :$literal ]
    }
    multi sub op(Str $op! where 'TJ',
        Array $args!) {
        my @array = $args.map({
            when Str     { :literal($_) }
            when Numeric { :int(.Int) }
            when Pair    { $_ }
            default {die "invalid entry in TJ array: {.perl}"}
        });
        $op => [ :@array ];
    }
    multi sub op(Str $op! where 'Tf',
        Str $name!, Numeric $real!) {
        $op => [ :$name, :$real ]
    }
    multi sub op(Str $op! where 'BDC' | 'DP',
        Str $name!, Hash $dict!) {
        $op => [ :$name, :$dict ]
    }
    multi sub op(Str $op! where 'd' | 'i' | 'g' | 'G' | 'M' | 'MP' | 'Tc' | 'TL' | 'Ts' | 'Tw' | 'Tz' | 'w',
        Numeric $real!) {
        $op => [ :$real ]
    }
    multi sub op(Str $op! where 'j' | 'J' | 'Tr',
        Int $int!) {
        $op => [ :$int ]
    }
    multi sub op(Str $op! where 'd0' | 'l' | 'm' | 'Td' | 'TD',
        Numeric $n1!, Numeric $n2!) {
        $op => [ :real($n1), :real($n2) ]
    }
    multi sub op(Str $op! where '"',
        Numeric $n1!, Numeric $n2!, Str $literal! ) {
        $op => [ :real($n1), :real($n2), :$literal ]
    }
    multi sub op(Str $op! where 'rg' | 'RG',
        Numeric $n1!, Numeric $n2!, Numeric $n3!) {
        $op => [ :real($n1), :real($n2), :real($n3) ]
    }
    multi sub op(Str $op! where 'k' | 'K' | 're' | 'SC' | 'sc' | 'v' | 'y',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4) ]
    }
    multi sub op(Str $op! where 'c' | 'cm' | 'd1' | 'Tm',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!, Numeric $n5!, Numeric $n6!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4), :real($n5), :real($n6) ]
    }
    multi sub op(Str $op! where 'scn' | 'SCN', *@args is copy) {

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
    multi sub op(Str $op!, *@args) {
        die "bad operation: $op @args[]";
    }
    #| semi-raw and a little dwimmy e.g:  op('TJ' => [[:literal<a>, :hex-string<b>, 'c']])
    #|                                     --> :TJ( :array[ :literal<a>, :hex-string<b>, :literal<c> ] )
    multi sub op(Pair $raw!) {
        my $op = $raw.key;
        my $input_vals = $raw.value;
        # validate the operation and get fallback coercements for any missing pairs
        my @vals = $raw.value.map({ from-ast($_) });
        my $opn = op($op, |@vals);
        unless $opn ~~ Str {
            my $coerced_vals = $opn.value;
            # looks ok, pass it thru
            my @ast-values = $input_vals.pairs.map({ .value ~~ Pair
                                                        ?? .value
                                                        !! $coerced_vals[.key] });
            $opn = $op => [ @ast-values ];
        }
        $opn;
    }
    multi sub op(*@args) is default {
        die "unknown op: {@args.perl}";
    }

    multi method op(*@args, :$prepend) {
        my $opn = op(|@args);
        $prepend ?? @!ops.unshift($opn) !! @!ops.push($opn);
    }
    method ops(Array $ops?) is rw {
        @!ops.push: $ops.map({ op($_) })
            if $ops.defined;
        @!ops;
    }

    method content {
        use PDF::Writer;
        my $writer = PDF::Writer.new;
        my @content = @!ops;
        $writer.write( :@content );
    }

}
