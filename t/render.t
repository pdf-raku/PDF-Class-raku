use v6;
use PDF::Doc;
use PDF::Grammar::Test :is-json-equiv;
use Test;

plan 11;

my $pdf = PDF::Doc.open: "t/helloworld.pdf";
my $page = $pdf.page: 1;

my %seen;
# image 2 is painted 3 times
my @img-seq = <Im1 Im2 Im2 Im2>;

my sub callback($op, *@args, :$gfx) {
   %seen{$op}++;
   given $op {
       when 'Do' {
           does-ok $gfx, ::('PDF::Graphics'), ':gfx argument';
           is-json-equiv @args, [shift @img-seq], 'Do callback arguments';
       }
   }
}

$page.render(&callback);

ok +%seen > 10, 'Operator spread';
ok +%seen<Q> > 3, '"Q" (save) operator spread';
is %seen<Q>, %seen<q>, 'Q ... q pairs';

done-testing;
