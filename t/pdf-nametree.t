use v6;
use Test;

plan 8;

use PDF::Class;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::COS;
use PDF::NameTree;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
20 0 obj <<
   /Kids [ 10 0 R ]
   /Names [ (1.1)  /Xxx  (1.2)  42 ]
   /Limits [10 20]
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my %ast = $/.ast;
my $reader = class { has $.auto-deref = False }.new;
my $ind-obj = PDF::IO::IndObj.new( |%ast, :$reader);
is $ind-obj.obj-num, 20, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $nametree-obj = PDF::COS.coerce($ind-obj.object, PDF::NameTree);
does-ok $nametree-obj, PDF::NameTree;
is-json-equiv $nametree-obj.Kids, [:ind-ref[10, 0]], '$obj.First';
is-json-equiv $nametree-obj.Names, [ '1.1', 'Xxx', '1.2', 42 ], '$obj.Names';
is-json-equiv $nametree-obj.names.List, ( '1.1' => 'Xxx', '1.2' => 42 ), '$obj.names';
is-json-equiv $nametree-obj.Limits, [10, 20], '$obj.Limits';
lives-ok {$nametree-obj.check}, '$nametree-obj.check lives';

