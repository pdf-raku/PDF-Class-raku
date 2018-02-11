use v6;
use Test;

plan 63;

use PDF::Class;
use PDF::Function::PostScript;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
10 0 obj <<
  /FunctionType 4
  /Domain [ -1.0 1.0 -1.0 1.0 ]
  /Range [ -1.0 1.0 ]
  /Length 56
>> stream
{ 360 mul sin
  2 div
  exch 360 mul sin
  2 div
  add
}
endstream
endobj
--END-OBJ--

sub parse-ind-obj($input) {
    PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
        // die "parse failed";
    my %ast = $/.ast;
    PDF::IO::IndObj.new( :$input, |%ast);
}

my $ind-obj = parse-ind-obj($input);
is $ind-obj.obj-num, 10, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $function-obj = $ind-obj.object;
isa-ok $function-obj, PDF::Function::PostScript;
is $function-obj.FunctionType, 4, '$.FunctionType accessor';
is $function-obj.type, 'Function', '$.type accessor';
is $function-obj.subtype, 'PostScript', '$.subtype accessor';
is-json-equiv $function-obj.Domain, [ -1.0, 1.0, -1.0, 1.0 ], '$.Domain accessor';
is-json-equiv $function-obj.Length, 56, '$.Length accessor (corrected)';

my $ast = $function-obj.parse;
is-json-equiv $ast, {:expr([:int(360), :op<mul>, :op<sin>, :int(2), :op<div>, :op<exch>, :int(360), :op<mul>, :op<sin>, :int(2), :op<div>, :op<add>])}, '$.parse accessor';

sub evaluate(Str $expr, @stack) {
    use PDF::Grammar::Function;
    use PDF::Grammar::Function::Actions;
    my  PDF::Grammar::Function::Actions $actions .= new;
    my $input = "\{$expr\}";
    PDF::Grammar::Function.parse($input, :$actions)
        // die "function parse failed: $input";
    my PDF::Function::PostScript::Calculator $ps .= new: :@stack, :domain(-Inf..Inf), :range(-Inf..Inf);
    $ps.run(|$/.ast);
    $ps.stack;
}

is-deeply evaluate('', [2, 5]), [2, 5], 'null expression';
is-deeply evaluate('add', [2, 5]), [7], 'add op';
is-deeply evaluate('sub', [23, 4]), [19], 'sub op';
is-deeply evaluate('mul', [3, 4]), [12], 'mul op';
is-deeply evaluate('div', [13, 2]), [6.5], 'div op';
is-deeply evaluate('idiv', [13, 2]), [6], 'idiv op';
is-deeply evaluate('mod', [13, 7]), [6], 'mod op';
is-deeply evaluate('neg', [13,]), [-13], 'neg op';
is-deeply evaluate('abs', [-13,]), [13], 'abs op';
is-deeply evaluate('ceiling', [2.3,]), [3], 'ceiling op';
is-deeply evaluate('floor', [2.3,]), [2], 'floor op';
is-deeply evaluate('round', [2.4,]), [2], 'round op';
is-deeply evaluate('round', [2.6,]), [3], 'round op';
is-deeply evaluate('truncate', [-2.3,]), [-2], 'truncate op';
is-approx evaluate('sqrt', [2])[0], 2.sqrt, 'sqrt op';

is-approx evaluate('sin', [90],)[0], 1, 'sin op';
is-approx evaluate('sin', [180],)[0], 0, 'sin op';

is-approx evaluate('cos', [90],)[0], 0, 'cos op';
is-approx evaluate('cos', [180],)[0], -1, 'cos op';

is-approx evaluate('atan', [1, 0,],)[0], 90, 'atan 1 0';
is-approx evaluate('atan', [1, 1,],)[0], 45, 'atan 1 1';
is-approx evaluate('atan', [1, -1,],)[0], 135, 'atan 1 -1';
is-approx evaluate('atan', [-1, -1,],)[0], 225, 'atan -1 -1';
is-approx evaluate('atan', [-1, 1,],)[0], 315, 'atan -1 1';

is-deeply evaluate('exp', [2,3]), [8], 'exp';

is-approx evaluate('ln', [2])[0], 2.log, 'ln op';
is-approx evaluate('log', [2])[0], 2.log10, 'log op';

is-deeply evaluate('cvi', [-2.3,]), [-2], 'cvi op';
is-deeply evaluate('cvr', [-2,]), [-2e0], 'cvr op';

is-deeply evaluate('{ 42 } if', [True]), [42,], 'if (true)';
is-deeply evaluate('{ 42 } if', [False]), [], 'if (false)';

is-deeply evaluate('2 3 eq 2 2 eq', []), [False, True], 'eq';
is-deeply evaluate('2 3 ne 2 2 ne', []), [True, False], 'eq';
is-deeply evaluate('3 2 ge 2 2 ge 2 3 ge', []), [True, True, False], 'ge';
is-deeply evaluate('3 2 lt 2 2 lt 2 3 lt', []), [False, False, True], 'lt';
is-deeply evaluate('3 2 le 2 2 le 2 3 le', []), [False, True, True], 'le';
is-deeply evaluate('and', [0b11011, 0b10101]), [0b10001], 'and';
is-deeply evaluate('or', [0b1010, 0b0110]), [0b1110], 'or';
is-deeply evaluate('xor', [0b11011, 0b10101]), [0b01110], 'xor';
is-deeply evaluate('not', [0b10101]), [-0b10110], 'not';
is-deeply evaluate('5 2 bitshift', []), [20], 'bitshift';
is-deeply evaluate('5 -1 bitshift', []), [2], 'bitshift';
is-deeply evaluate('true false', []), [True, False], 'true/false';

is-deeply evaluate('2 1 1 add eq { 6 7 mul } { 69 } ifelse', []), [42,], 'ifelse (true)';
is-deeply evaluate('2 1 1 add ne { 6 7 mul } { 69 } ifelse', []), [69,], 'ifelse (false)';

is-deeply evaluate('exch', [12, 2]), [2,12], 'exch op';
is-deeply evaluate('dup', [10, 20]), [10,20,20], 'dup';
is-deeply evaluate('2 copy', [10, 20, 30]), [10,20,30, 20,30], 'copy';
is-deeply evaluate('1 index', [10, 20, 30]), [10,20,30, 20], 'index';
is-deeply evaluate('2 1 roll', [10, 20, 30]), [10,30,20], 'roll';

todo "typecheck Bool vs Numeric";
dies-ok {evaluate('add', [2, True])}, 'typecheck';
dies-ok {evaluate('add', [2])}, 'stack underflow';

is-approx $function-obj.evaluate([-.5, -.5])[0], 0, 'function calc';
is-approx $function-obj.evaluate([.1, .1])[0], 0.587785, 'function calc';

