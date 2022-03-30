use v6;
use Test;
use PDF::Class;
use PDF::StructTreeRoot;
use PDF::StructElem :Attributes;

my PDF::Class $pdf;
lives-ok {$pdf .= open("t/pdf/samples/tagged.pdf")}, "open form example  lives";

my PDF::StructTreeRoot $root = $pdf.catalog.StructTreeRoot;

is $root.RoleMap<DD>, 'LBody';
my PDF::StructElem $doc = $root.K;

is $doc.S, 'Document';
cmp-ok $doc.P, '===', $root;

my PDF::StructElem $elem = $doc.kids[0];

is $elem.S, 'L';

my Attributes @att-objs = $elem.attribute-dicts;
is +@att-objs, 1;
my $att = @att-objs[0];
is $att.owner, 'List';
is $att<ListNumbering>, 'Disc';

done-testing;
