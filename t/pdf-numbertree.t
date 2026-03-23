use v6;
use Test;

plan 10;

use PDF::Class;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::COS;
use PDF::NumberTree :NumberTree;

my PDF::Grammar::PDF::Actions $actions .= new: :lite;

my $input = q:to"--END-OBJ--";
20 0 obj <<
   /Nums [ 20  /Xxx  30  42 ]
   /Limits [20 30]
   /Kids []
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
my  PDF::NumberTree() $numtree-obj = $ind-obj.object;
does-ok $numtree-obj, PDF::NumberTree;
is-json-equiv $numtree-obj.Kids, [], '$obj.First';
is-json-equiv $numtree-obj.Nums, [ 20, 'Xxx', 30, 42 ], '$obj.Nums';
my NumberTree $nums = $numtree-obj.number-tree;
is-json-equiv $nums{30}, 42, '.nums deref';
is-json-equiv $nums.Hash, { 20 => 'Xxx', 30 => 42 }, '$obj.nums';
is-json-equiv $numtree-obj.Limits, [20, 30], '$obj.Limits';
lives-ok {$numtree-obj.check}, '$numtree-obj.check lives';

$nums[50] = 99;
$numtree-obj.cb-finish();
is-json-equiv $numtree-obj.Nums, [ 20, 'Xxx', 30, 42, 50, 99], '$obj.Nums after update';
