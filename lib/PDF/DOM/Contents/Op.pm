use v6;

use PDF::Writer;
use PDF::Object :from-ast;

role PDF::DOM::Contents::Op {

    has @!ops;

    multi sub op(Str $op! where 'BT' | 'ET' | 'EMC' | 'BI' | 'ID' | 'EI' | 'BX' | 'EX' | 'b*' | 'b' | 'B*' | 'B'
                                  | 'f*' | 'F' | 'f' | 'h' | 'n' | 'q' | 'Q' | 's' | 'S' | 'T*' | 'W*' | 'W') {
        $op;
    }
    #| tag                     BMC | MP
    #| name                    cs | CS | Do | sh
    #| dictname                gs
    #| intent                  ri
    multi sub op(Str $op! where 'BMC' | 'cs' | 'CS' | 'Do' | 'gs' | 'MP' | 'ri' | 'sh',
        Str $name!) {
        $op => [ :$name ]
    }
    #| string                  Tj | '
    multi sub op(Str $op! where 'Tj' | "'",
        Str $literal!) {
        $op => [ :$literal ]
    }
    #| array                   TJ
    multi sub op(Str $op! where 'TJ',
        Array $args!) {
        my @array = $args.map({
            when Str     { :literal($_) }
            when Numeric { :int(.Int) }
            when Pair    { $_ }
            default {die "invalid entry in $op array: {.perl}"}
        });
        $op => [ :@array ];
    }
    multi sub op(Str $op! where 'Tf',
        Str $name!, Numeric $real!) {
        $op => [ :$name, :$real ]
    }
    #| name dict              BDC | DP
    multi sub op(Str $op! where 'BDC' | 'DP',
        Str $name!, Hash $dict!) {
        $op => [ :$name, :$dict ]
    }
    #| dashArray dashPhase    d
    multi sub op(Str $op! where 'd',
        Array $args!, Numeric $real!) {
        my @array = $args.map({
            when Int     { :int(.Int) }
            when Pair    { $_ }
            default {die "invalid entry in $op array: {.perl}"}
        });
        $op => [ :@array, :$real ];
    }
    #| flatness               i
    #| gray                   g | G
    #| miterLimit             m
    #| charSpace              Tc
    #| leading                TL
    #| rise                   Ts
    #| wordSpace              Tw
    #| scale                  Tz
    #| lineWidth              w
    multi sub op(Str $op! where 'i' | 'g' | 'G' | 'M' | 'Tc' | 'TL' | 'Ts' | 'Tw' | 'Tz' | 'w',
        Numeric $real!) {
        $op => [ :$real ]
    }
    #| lineCap                J
    #| lineJoin               j
    #| render                 Tr
    multi sub op(Str $op! where 'j' | 'J' | 'Tr',
        Int $int!) {
        $op => [ :$int ]
    }
    #| x y                    m l
    #| wx wy                  d0
    #| tx ty                  Td TD
    multi sub op(Str $op! where 'd0' | 'l' | 'm' | 'Td' | 'TD',
        Numeric $n1!, Numeric $n2!) {
        $op => [ :real($n1), :real($n2) ]
    }
    #| aw ac string           "
    multi sub op(Str $op! where '"',
        Numeric $n1!, Numeric $n2!, Str $literal! ) {
        $op => [ :real($n1), :real($n2), :$literal ]
    }
    #| r g b                  rg | RG
    multi sub op(Str $op! where 'rg' | 'RG',
        Numeric $n1!, Numeric $n2!, Numeric $n3!) {
        $op => [ :real($n1), :real($n2), :real($n3) ]
    }
    #| c m y k                k | K
    #| x y width height       re
    #| x2 y2 x3 y3            v y
    multi sub op(Str $op! where 'k' | 'K' | 're' | 'v' | 'y',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4) ]
    }
    #| x1 y1 x2 y2 x3 y3      c | cm
    #| wx wy llx lly urx ury  d1
    #| a b c d e f            Tm
    multi sub op(Str $op! where 'c' | 'cm' | 'd1' | 'Tm',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!, Numeric $n5!, Numeric $n6!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4), :real($n5), :real($n6) ]
    }
    # c1, ..., cn             sc | SC
    multi sub op(Str $op! where 'sc' | 'SC', *@args is copy) {

        die "too few arguments to: $op"
            unless @args;

        @args = @args.map({ 
            when Pair    {$_}
            when Numeric { :real($_) }
            default {
                die "$op: bad argument: {.perl}"
            }
        });

        $op => [ @args ]
    }
    # c1, ..., cn [name]      scn | SCN
    multi sub op(Str $op! where 'scn' | 'SCN', *@args is copy) {

        # scn & SCN have an optional trailing name
        my $name = @args.pop
            if +@args && @args[*-1] ~~ Str;

        die "too few arguments to: $op"
            unless $name.defined || @args;

        @args = @args.map({ 
            when Pair    {$_}
            when Numeric { :real($_) }
            default {
                die "$op: bad argument: {.perl}"
            }
        });

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
    method ops(Array $ops?) {
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
