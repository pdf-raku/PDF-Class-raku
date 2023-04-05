use v6;
use Test;

plan 11;

use PDF::Class;
use PDF::IO::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::COS;
use PDF::NameTree :NameTree;

my PDF::Grammar::PDF::Actions $actions .= new: :lite;

my $input = q:to"--END-OBJ--";
20 0 obj <<
   /Kids [ <<
       /Names [ (1.1)  /Xxx  (1.2)  42 (1.3) 3.14 ]
       /Limits [(1.1) (1.3)]
   >> ]
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
my PDF::NameTree $nametree-obj .= COERCE: $ind-obj.object;
does-ok $nametree-obj, PDF::NameTree;
is-json-equiv $nametree-obj.Kids[0].Names, [ '1.1', 'Xxx', '1.2', 42, '1.3', 3.14 ], '$obj.Kids[0].Names';
my NameTree $names = $nametree-obj.name-tree;
for '1.1' => 'Xxx', '1.2' => 42, '1.3' => 3.14 {
   is $names{.key}, .value, "names\{{.key}\}";
}
is-deeply $names.keys.sort, ('1.1', '1.2', '1.3'), '$.keys';
lives-ok {$nametree-obj.check}, '$nametree-obj.check lives';

$names<1.4> = 99;
$nametree-obj.cb-finish();
is-json-equiv $nametree-obj.Names, [ '1.1', 'Xxx', '1.2', 42, '1.3', 3.14, '1.4', 99 ], '$obj.Names after rebuild';
ok !defined($nametree-obj.Kids), '$obj.Kids after rebuild';
