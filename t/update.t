use v6;
use Test;
use PDF::DOM;
't/helloworld.pdf'.IO.copy('t/update-incremental.pdf');
my $pdf = PDF::DOM.open('t/update-incremental.pdf');
my $new-page = $pdf.Pages.add-page;
$new-page.gfx.text( 'New Last Page!!', :left(50), :top(300) );
ok $pdf.update, 'update';

$pdf = PDF::DOM.open('t/update-incremental.pdf');
ok $pdf.Pages.find-page(2), 'pdf now has two pages';

ok $pdf.save-as('t/update-resaved.json'), 'save-as json';
$pdf = PDF::DOM.open('t/update-resaved.json');
ok $pdf.Pages.find-page(2), 'pdf reload from json';

done;
