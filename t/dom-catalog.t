use v6;
use Test;

plan 18;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
215 0 obj
<< /Lang (EN-US) /LastModified (D:20081012130709)
   /MarkInfo << /LetterspaceFlags 0 /Marked true >> /Metadata 10 0 R
   /Outlines 18 0 R /PageLabels 210 0 R /PageLayout /OneColumn /Pages 212 0 R
   /PieceInfo << /MarkedPDF << /LastModified (D:20081012130709) >> >>
   /StructTreeRoot 25 0 R
   /Type /Catalog
>>
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 215, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $catalog = $ind-obj.object;
isa-ok $catalog, ::('PDF::DOM::Type')::('Catalog');
is $catalog<PageLayout>, 'OneColumn', 'dict lookup';
is-json-equiv $catalog.Lang, 'EN-US', '$catalog.Lang';
# last modified is not listed as a property in [ PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
is-json-equiv $catalog<LastModified>, 'D:20081012130709', '$catalog<LastModified>';
is-json-equiv $catalog.MarkInfo, { :LetterspaceFlags(0), :Marked }, '$object.MarkInfo'; 
is-json-equiv $catalog.Metadata, (:ind-ref[10, 0]), '$catalog.Metadata';
is-json-equiv $catalog.Outlines, (:ind-ref[18, 0]), '$catalog.Outlines';
is-json-equiv $catalog.PageLabels, (:ind-ref[210, 0]), '$catalog.PageLabels';
is-json-equiv $catalog.PageLayout, 'OneColumn', '$catalog.PageLayout';
is-json-equiv $catalog.Pages, (:ind-ref[212, 0]), '$catalog.Pages';
is-json-equiv $catalog.PieceInfo, { :MarkedPDF{ :LastModified<D:20081012130709> } }, '$catalog.PieceInfo';
is-json-equiv $catalog.StructTreeRoot, (:ind-ref[25, 0]), '$catalog.StructTreeRoot';
is-json-equiv $ind-obj.ast, $ast, 'ast regeneration';
is-json-equiv $catalog.Type, 'Catalog', '$catalog.Type';

lives-ok {$catalog.core-font('Helvetica')}, 'can add resource (core-font) to catalog';
is-json-equiv $catalog.Resources, {:Font{
    :F1{
        :Type<Font>, :Subtype<Type1>, :Encoding<WinAnsiEncoding>, :BaseFont<Helvetica>,
    }}
}, '$.Resources accessor';

