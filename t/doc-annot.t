use v6;

use Test;
use PDF::Doc;
use PDF::Doc::Op :OpNames;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Storage::IndObj;

# ensure consistant document ID generation
srand(123456);

my $input = q:to"--END--";
22 0 obj <<
  /Type /Annot
  /Subtype /Text
  /Rect [ 100 100 300 200 ]
  /Contents (This is an open annotation. You'll need acro-reader...)
  /Open true
>> endobj
--END--

my $actions = PDF::Grammar::PDF::Actions.new;
PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
my %ast = $/.ast;

my $reader = class { has $.auto-deref = False }.new;

my $ind-obj = PDF::Storage::IndObj.new( :$input, |%ast, :$reader );
my $text-annot = $ind-obj.object;
isa-ok $text-annot, ::('PDF::Doc::Type::Annot::Text');
is-json-equiv $text-annot.Rect, [ 100, 100, 300, 200 ], '.Rect';
is $text-annot.Contents, "This is an open annotation. You'll need acro-reader...", '.Contents';

my $open-text-annot = ::('PDF::Doc::Type::Annot::Text').new(:dict{
    :Rect[ 120, 120, 200, 200],
    :Contents("...xpdf doesn't display annotations. This annotation is closed, btw"),
    :!Open,
});

is-deeply $open-text-annot.Open, False, '.Open';

my $pdf = PDF::Doc.new;
my $page = $pdf.Pages.add-page;
$page<MediaBox> = [0, 0, 350, 250];
$page<Annots> = [ $text-annot, $open-text-annot ];
$page.gfx.BeginText;
$page.gfx.TextMove(50, 50);
$page.gfx.say('Page with an open annotation');
$page.gfx.EndText;

$pdf.save-as('t/doc-annot.pdf');

$input = q:to"--END--";
93 0 obj <<
  %%  /Type /Annot   % Type is optional
  /Subtype /Link
  /Rect [ 71 717 190 734 ]
  /Border [ 16 16 1 ]
  /Dest [ 3 0 R /FitR -4 399 199 533 ]
>> endobj
--END--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
%ast = $/.ast;

$ind-obj = PDF::Storage::IndObj.new( :$input, |%ast, :$reader );
my $link-annot = $ind-obj.object;
isa-ok $link-annot, ::('PDF::Doc::Type::Annot::Link');
is $link-annot.Type, 'Annot', 'Annot with /Type defaulted';
is-json-equiv $link-annot.Border, [ 16, 16, 1 ], '.Border';
is-json-equiv $link-annot.Dest, [ :ind-ref[3, 0], 'FitR', -4, 399, 199, 533], '.Dest';

done-testing;
