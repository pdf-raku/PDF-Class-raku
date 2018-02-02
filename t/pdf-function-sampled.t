use v6;
use Test;

plan 10;

use PDF::Class;
use PDF::Function::Sampled;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
6 0 obj <<
  /FunctionType 0
  /BitsPerSample 8
  /Domain [ 0 1 ]
  /Filter /ASCIIHexDecode
  /Range [ 0 1 0 0.66667 0 0.6 0 0.33333 ]
  /Size [ 2 ]
  /Length 17
>> stream
00000000FFFFFFFF>
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
my $function-obj = $ind-obj.object;
isa-ok $function-obj, PDF::Function::Sampled;
is $function-obj.FunctionType, 0, '$.FunctionType accessor';
is $function-obj.type, 'Function', '$.type accessor';
is $function-obj.subtype, 'Sampled', '$.subtype accessor';
is-json-equiv $function-obj.Domain, [0, 1], '$.Domain accessor';
is-json-equiv $function-obj.Length, 17, '$.Length accessor (corrected)';

sub is-calc($a, $b, $test = 'calc') {
    my $ok = $a.elems == $b.elems
        && !$a.keys.first({($a[$_] - $b[$_]).abs >= 0.01 }).defined;
    ok $ok, $test;
    diag "expected {$a.perl}, got {$b.perl}"
        unless $ok;
    $ok
}

is-calc $function-obj.calc([0]), [0, 0, 0, 0];
todo "unstub sampled function", 3;
is-calc $function-obj.calc([1]), [1, 0.666, 0.6, 0.333];
is-calc $function-obj.calc([.5]), [0.5, 0.333, 0.30, 0.167];
is-calc $function-obj.calc([.3]), [0.3, 0.2, 0.18, 0.1];


