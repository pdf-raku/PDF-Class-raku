use v6;
use Test;

plan 24;

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
  /Range [ 0 1 0 1 0 1 0 1 ]
  /Size [ 2 ]
  /Length 17
>> stream
00112130FFFFFFA0>
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
is-json-equiv $function-obj.Length, 17, '$.Length accessor';

sub is-calc($a, $b, $test = 'calc') {
    my $ok = $a.elems == $b.elems
        && !$a.keys.first({($a[$_] - $b[$_]).abs >= 0.01 }).defined;
    ok $ok, $test;
    diag "expected {$b.perl}, got {$a.perl}"
        unless $ok;
    $ok
}

is-calc $function-obj.calc([0]), [0, 17/255, 33/255, 48/255];
is-calc $function-obj.calc([1]), [1, 1, 1, 160/255];
is-calc $function-obj.calc([.5]), [1/2, 136/255, 144/255, 104/255];
is-calc $function-obj.calc([.25]), [1/4, 3/10, 88.5/255, 76/255];

$function-obj.Encode = [0, 2];

is-calc $function-obj.calc([0]), [0, 17/255, 33/255, 48/255];
is-calc $function-obj.calc([1]), [1, 1, 1, 160/255];
is-calc $function-obj.calc([.5]), [1, 1, 1, 160/255];
is-calc $function-obj.calc([.25]), [1/2, 136/255, 144/255, 104/255];

$function-obj.Encode = [0, .8];

is-calc $function-obj.calc([.5]), [0.400000, 0.440000, 0.477647, 0.363922];
is-calc $function-obj.calc([1]), [0.800000, 0.813333, 0.825882, 0.539608];

$function-obj.Encode = [0, 1];
$function-obj.Range = [0, 1, -1, 1, 0, 2, 1, 2];

is-calc $function-obj.calc([0]), [0, -221/255, 66/255, 303/255];
is-calc $function-obj.calc([.5]), [1/2, 17/255, 288/255, 359/255];
is-calc $function-obj.calc([1]), [1, 1, 2, 415/255];
is-calc $function-obj.calc([.25]), [1/4, -102/255, 177/255, 331/255];

todo "Size tests", 4;

$function-obj.encoded = '00112130A1A2A3A4FFFFFFA0>';
$function-obj.Encode = [0, 1];
$function-obj.Size = 3;

is-calc $function-obj.calc([0]), [0, 17/255, 33/255, 48/255];
is-calc $function-obj.calc([1]), [1, 1, 1, 160/255];
is-calc $function-obj.calc([.5]), [161/255, 162/255, 163/255, 164/255]; #?? check on 4th value
is-calc $function-obj.calc([.25]), [80.5/255, 89.5/10, 98/255, 106/255];


