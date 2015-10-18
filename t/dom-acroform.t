use v6;
use PDF::DOM;
use PDF::Grammar::Test :$is-json-equiv;
use Test;
my $dom;

lives-ok {$dom = PDF::DOM.open("t/pdf/samples/OoPdfFormExample.pdf")}, "open form example  lives";

my $doc = $dom.Root;
isa-ok $doc, ::('PDF::DOM::Type::Catalog'), 'document root';

my $acroform = $doc.AcroForm;
does-ok $doc.AcroForm, ::('PDF::DOM::Type::AcroForm');

my @fields = $acroform.fields;
isa-ok @fields, Array, '.Fields';
is +@fields, 17, 'fields count';
does-ok @fields[0], ::('PDF::DOM::Type::Field'), '.Fields';
isa-ok @fields[0], ::('PDF::DOM::Type::Annot::Widget'), 'field type';

is @fields[0].Type, 'Annot', 'Type';
is @fields[0].Subtype, 'Widget', 'Subtype';
is @fields[0].F, 4, '.F';
is @fields[0].FT, 'Tx', '.FT';
isa-ok @fields[0]<P>, ::('PDF::DOM::Type::Page'), '<P>';
my $page = @fields[0].P;
isa-ok $page, ::('PDF::DOM::Type::Page'), '.P';
is-json-equiv @fields[0].Rect, [165.7, 453.7, 315.7, 467.9], '.Rect';
is @fields[0].T, 'Given Name Text Box', '.T';
is @fields[0].TU, 'First name', '.TU';
is @fields[0].V, "\c[0xFE]\c[0xFF]", '.V';
is @fields[0].DV, "\c[0xFE]\c[0xFF]", '.DV';
is @fields[0].MaxLen, 40, '.MaxLen';
isa-ok @fields[0].DR, Hash, '.DR';
ok @fields[0].DR<Font>:exists, '.DR<Font>';
is @fields[0].DA, '0 0 0 rg /F3 11 Tf', '.DA';
isa-ok @fields[0].AP, Hash, '.AP';
ok @fields[0].AP<N>:exists, '.AP<N>';
ok $page.Annots[0] === @fields[0], 'first field via page-1 annots';

my %fields = $acroform.fields-hash;
is +%fields, 25, 'fields hash key count';
ok %fields{'Given Name Text Box'} == @fields[0], 'field hash lookup by .T';
ok %fields{'First name'} == @fields[0], 'field hash lookup by .TU';

# check meta-data
isa-ok $doc.reader, ::('PDF::Reader'), '$doc.reader';
isa-ok $doc.AcroForm.reader, ::('PDF::Reader'), '$doc.AcroForm.reader';
isa-ok @fields[0].reader, ::('PDF::Reader'), '$doc.AcroForm.Fields[0].reader';
is @fields[0].obj-num, 5, '.obj-num';
is @fields[0].gen-num, 0, '.gen-num';
isa-ok @fields[0].P.reader, ::('PDF::Reader'), '$doc.AcroForm.Fields[0].P.reader';

done-testing;
