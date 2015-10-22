use v6;

use Test;
use PDF::DOM;
use PDF::DOM::Op :OpNames;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Storage::IndObj;

my $input = q:to"--END--";
22 0 obj
<< /Type /Annot
/Subtype /Text
/Rect [ 100 100 300 200 ]
/Contents (This is an open annotation. You'll need acro-reader...)
/Open true
>>
endobj
--END--

my $actions = PDF::Grammar::PDF::Actions.new;
PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
my $ast = $/.ast;

my $ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $text-annot = $ind-obj.object;
isa-ok $text-annot, ::('PDF::DOM::Type::Annot::Text');
is-json-equiv $text-annot.Rect, [ 100, 100, 300, 200 ], '.Rect';
is $text-annot.Contents, "This is an open annotation. You'll need acro-reader...", '.Contents';

my $open-text-annot = ::('PDF::DOM::Type::Annot::Text').new(:dict{
    :Rect[ 120, 120, 200, 200],
    :Contents("...xpdf doesn't display annotations. This annotation is closed, btw"),
    :Open(False),
});

is-deeply $open-text-annot.Open, False, '.Open';

my $pdf = PDF::DOM.new;
my $page = $pdf.Pages.add-page;
$page.media-box(350, 250);
$page<Annots> = [ $text-annot, $open-text-annot ];
$page.gfx.BeginText;
$page.gfx.TextMove(50, 50);
$page.gfx.say('Page with an open annotation');
$page.gfx.EndText;

$pdf.save-as('t/dom-annot.pdf');

$input = q:to"--END--";
93 0 obj
<< /Type /Annot
/Subtype /Link
/Rect [ 71 717 190 734 ]
/Border [ 16 16 1 ]
/Dest [ 3 0 R /FitR -4 399 199 533 ]
>>
endobj
--END--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
$ast = $/.ast;

$ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $link-annot = $ind-obj.object;
isa-ok $link-annot, ::('PDF::DOM::Type::Annot::Link');
is-json-equiv $link-annot.Border, [ 16, 16, 1 ], '.Border';
is-json-equiv $link-annot.Dest, [ :ind-ref[3, 0], 'FitR', -4, 399, 199, 533], '.Dest';

done-testing;
