use v6;
use PDF::Doc;
use PDF::Grammar::Test :is-json-equiv;
use Test;

plan 5;

my $pdf = PDF::Doc.open: "t/helloworld.pdf";
my $page = $pdf.page: 1;

my %seen;

my sub callback($op, *@args, :$gfx) {
   %seen{$op}++;
   given $op {
       when 'Do' {
           isa-ok $gfx, ::('PDF::Doc::Contents::Gfx'), ':gfx argument';
           is-json-equiv @args, ['Im1'], 'Do callback arguments';
       }
   }
}

$page.render(&callback);

ok +%seen > 10, 'Operator spread';
ok +%seen<Q> > 3, '"Q" (save) operator spread';
is %seen<Q>, %seen<q>, 'Q ... q pairs';

done-testing;
