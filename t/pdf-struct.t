use v6;
use Test;
use PDF::Class;
use PDF::StructTreeRoot;
use PDF::StructElem;
use PDF::Attributes;
use PDF::Attributes::Layout;
use PDF::Attributes::List;

my PDF::Class $pdf;
lives-ok {$pdf .= open("t/pdf/samples/tagged.pdf")}, "open form example  lives";

my PDF::StructTreeRoot $root = $pdf.catalog.StructTreeRoot;

is $root.RoleMap<DD>, 'LBody';
my PDF::StructElem $doc = $root.K;

is $doc.S, 'Document';
cmp-ok $doc.P, '===', $root;

my PDF::StructElem $elem = $doc.kids[0];

is $elem.S, 'L';

my PDF::Attributes @att-objs = $elem.attribute-dicts;
is +@att-objs, 1;
my $att = @att-objs[0];
is $att.owner, 'List';
does-ok $att, PDF::Attributes::List;
is $att<ListNumbering>, 'Disc';
is $att.ListNumbering, 'Disc';

$elem = $elem.kids[0].kids[1].kids[0].kids[0];
is $elem.S, 'Link';
@att-objs = $elem.attribute-dicts;
$att = @att-objs[0];
is $att.owner, 'Layout';
does-ok $att, PDF::Attributes::Layout;
is $att<TextDecorationType>, 'Underline';
is $att.TextDecorationType, 'Underline';

done-testing;
