use v6;
use Test;

plan 8;

use PDF::Class;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::COS;
use PDF::NumberTree;

my PDF::Grammar::PDF::Actions $actions .= new;

my $input = q:to"--END-OBJ--";
20 0 obj <<
   /Kids [ 10 0 R ]
   /Nums [ 20  /Xxx  30  42 ]
   /Limits [10 20]
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my %ast = $/.ast;
my $reader = class { has $.auto-deref = False }.new;
my PDF::IO::IndObj $ind-obj .= new( |%ast, :$reader);
is $ind-obj.obj-num, 20, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $nametree-obj = PDF::COS.coerce($ind-obj.object, PDF::NumberTree);
does-ok $nametree-obj, PDF::NumberTree;
is-json-equiv $nametree-obj.Kids, [:ind-ref[10, 0]], '$obj.First';
is-json-equiv $nametree-obj.Nums, [ 20, 'Xxx', 30, 42 ], '$obj.Nums';
is-json-equiv $nametree-obj.nums.List, ( 20 => 'Xxx', 30 => 42 ), '$obj.nums';
is-json-equiv $nametree-obj.Limits, [10, 20], '$obj.Limits';
lives-ok {$nametree-obj.check}, '$nametree-obj.check lives';

