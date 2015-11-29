# perl6-PDF-DOM

PDF::DOM is a Perl 6 module for the creation and manipulation of PDF files.

```
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

$pdf.save-as: "helloworld.pdf";
```

### Viewer Preferences
```
    use PDF::DOM;
    use PDF::DOM::Type::Catalog;
    my $pdf = PDF::DOM.new;
    my $doc = $pdf.Root;
    my $prefs = $doc.ViewerPreferences //= {};

    $prefs.Duplex = 'DuplexFlipShortEdge';
    $prefs.PageMode = 'UseOutlines';
    # ...etc, see PDF::DOM::Type::ViewerPreferences
```

## Development Status

This module is under construction and not yet functionally complete.
