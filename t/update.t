use v6;
use Test;
use PDF::DOM;
't/helloworld.pdf'.IO.copy('t/update-incremental.pdf');
my $pdf = PDF::DOM.open('t/update-incremental.pdf');
my $new-page = $pdf.Pages.add-page;
$new-page.gfx.say( 'New Last Page!!' );
ok $pdf.update, 'update';

$pdf = PDF::DOM.open('t/update-incremental.pdf');
ok $pdf.page(2), 'pdf now has two pages';

ok $pdf.save-as('t/update-resaved.json'), 'save-as json';
$pdf = PDF::DOM.open('t/update-resaved.json');
my $p2;
ok $p2 = $pdf.page(2), 'pdf reload from json';

my $p2-again;
lives-ok {$p2-again = $pdf.delete-page(2)}, 'delete-page lives';
ok $p2 === $p2-again, 'delete page returned';
is $pdf.pages, 1, 'pages after deletion';


done;
