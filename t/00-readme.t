use v6;
use Test;

lives-ok {
    use v6;
    use PDF::DOM;

    my $pdf = PDF::DOM.new;
    my $page = $pdf.add-page;
    $page.MediaBox = [0, 0, 595, 842];
    my $font = $page.core-font( :family<Helvetica>, :weight<bold> );
    $page.text: -> $_ {
        .text-position = [100, 150];
        .set-font: $font;
        .say: 'Hello, world!';
    }

    my $info = $pdf.Info = {};
    $info.CreationDate = DateTime.now;

   ##$pdf.save-as: "helloworld.pdf";
}, 'hello world';


lives-ok {
    use PDF::DOM;
    use PDF::DOM::Type::Catalog;
    my $pdf = PDF::DOM.new;
    my $doc = $pdf.Root;
    my $prefs = $doc.ViewerPreferences //= {};

    $prefs.Duplex = 'DuplexFlipShortEdge';
    $prefs.PageMode = 'UseOutlines';
    $prefs.NumCopies = 3;

}, 'page handling';

done-testing;
