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

### Page Layout & Viewer Preferences
```
    use PDF::DOM;
    use PDF::DOM::Type::Catalog;
    my $pdf = PDF::DOM.new;

    my $doc = $pdf.Root;
    $doc.PageLayout = 'TwoColumnLeft';
    $doc.PageMode   = 'UseThumbs';

    my $viewer-prefs = $doc.ViewerPreferences //= {};
    $viewer-prefs.Duplex = 'DuplexFlipShortEdge';
    $viewer-prefs.NonFullScreenPageMode = 'UseOutlines';
    # ...etc, see PDF::DOM::Type::ViewerPreferences
```

### General Content and Graphics

The PDF::DOM::Contents::Gfx role is performed by PDF::DOM::Type::Page (as shown here), and also PDF::DOM::Type::Pattern and PDF::DOM::Type::XObject::Form.

#### Low level graphics

```
use PDF::DOM;
my $doc = PDF::DOM.new;
my $page = $doc.add-page;

# Draw a simple Bézier curve:
sub draw-curve($gfx) {
    $gfx.Save;
    $gfx.MoveTo(175, 720);
    $gfx.LineTo(175, 700);
    $gfx.CurveTo1( 300, 800, 
                   400, 720 );
    $gfx.ClosePath;
    $gfx.Stroke;
    $gfx.Restore;
}

draw-curve($page.gfx);

$doc.save-as: "curve.pdf";
```
The .ops method can be used for input from data or strings:

1. from data
````
sub draw-curve2($gfx) {

    $gfx.ops: [
         'q',               # save,
         :m[175, 720],      # move-to
         :l[175, 700],      # line-to 
         :v[300, 800,
            400, 720],      # curve-to
         :h[],              # close
         'S',               # stroke
         'Q',               # restore
     ];
}
```

2. from a string of content instructions:

```
sub draw-curve3($gfx) {
    $gfx.ops: q:to"--END--"
        q                     % save
          175 720 m           % move-to
          175 700 l           % line-to
          300 800 400 720 v   % curve-to
          h                   % close
          S                   % stroke
        Q                     % restore
        --END--
}
```

For a full list of operators, please see PDF::DOM::Op.

## Development Status

This module is under construction and not yet functionally complete.
