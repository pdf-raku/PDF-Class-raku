# perl6-PDF-DOM

PDF::DOM is a set of intermediate Perl 6 classes for structured manupilation of PDF documents.

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

#### Text

`.say` and `.print` are simple convenience methods for displaying simple blocks of text with optional line-wrapping, alignment and kerning.

```
my $doc = $pdf.Root;
my $page = $doc.add-page;
my $font = $page.core-font( :family<Helvetica> );

$page.txt -> $txt {
    my $para = q:to"--END--";
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
    ut labore et dolore magna aliqua.
    --END--
            
    $txt.set-font($font, $font-size);
    $txt.say( $body, :width(200), :height(150) :align<right>, :kern);
}
```

#### Forms and images (`.image` and  `.do` methods):

The `.image` method can be used to load an image and register it as a page resource.
The `.do` method can them be used to render it.

```
	my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
	ok $img.Width, '$img.Width';
	$gfx.do($img, 232, 380, :width(150) );
```

Note: at this stage, only the `JPEG` image format is supported.

### Graphical effects and transformations

The following displays the image again semi-transparently with translation, rotation, scaling

```
    $page.graphics: -> $gfx {
	$gfx.transform( :translate[285, 250]);
	$gfx.transform( :rotate(-10), :scale(1.5) );
	$gfx.set-graphics( :transparency(.5) );
	$gfx.do($img, 232, 380, :width(150) );
    }
```

For a full description of `.set-graphics` options, please see PDF::DOM::Type::ExtGState.

### Text effects

To display card suits symbols, using the ZapfDingbats core-font. Diamond and hearts colored red:

```
    $page.text: -> $txt {
        $txt.text-position = [240, 600];
        $txt.set-font($page.core-font('ZapfDingbats'), 24);
        $txt.SetWordSpacing(16);
        my $nbsp = "\c[NO-BREAK SPACE]";
        $txt.print("♠ ♣$nbsp");
        $txt.SetFillRGB( 1, .3, .3);  # redish
	$txt.say("♦ ♥");
    }
```

Display outline, slanted text, using the ShowText (`Td`) operator:

```
    $page.text: -> $txt {
         use PDF::DOM::Op :TextMode;
        .set-font( $header-font, 12);
        .SetTextRender: TextMode::OutlineText;
        .SetLineWidth: .5;
        .text-transform( :translate[50, 550], :slant(12) );
        .ShowText('Outline Slanted Text @(50,550)');
     }
```

#### Low level graphics, colors and drawing

PDF::DOM::Contents::Gfx inherits from PDF::DOM::Op, which implements the full range of PDF content operations:

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

For a full list of operators, please see PDF::DOM::Op documentaton.


## Development Status

This module is under construction and not yet functionally complete.

# Bugs and Restrictions
At this stage:
- Only core fonts are supported. There are a total of 14
font variations available. Please see the Font::AFM module for details.
- Only JPEG images are supported. This is basically a port of PDF::API2::XObject::Image::JPEG
from the Perl 5 PDF::API2 module. Other image types should port fairly readily.
- The classess in the PDF::DOM::Type::* namespace represent a common subset of
the objects that can appear in a PDF. It is envisioned that the range of classes
with expand over time to cover most or all types described in the PDF specification.
- Many of the classes are skeletal at the moment and do little more that declare
fields for validation purposes; for example, the classes in the PDF::DOM::Type::Font::* namespace.
