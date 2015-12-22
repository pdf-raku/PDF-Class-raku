# perl6-PDF-DOM

PDF::DOM is a set of intermediate Perl 6 classes for structured manipulation of PDF documents.

It's goal is to implement a subset of the classes described in the PDF 1.7 Specification for general PDF
development.

```
use v6;
use PDF::DOM;

my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
$page.MediaBox = [0, 0, 595, 842];
my $font = $page.core-font( :family<Helvetica>, :weight<bold>, :style<italic> );
$page.text: -> $_ {
    .text-position = [100, 150];
    .set-font: $font;
    .say: 'Hello, world!';
}

my $info = $pdf.Info = {};
$info.CreationDate = DateTime.now;

$pdf.save-as: "t/example.pdf";
```

### Page Layout & Viewer Preferences
```
    use PDF::DOM;
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
use PDF::DOM;
use PDF::DOM::Type::Catalog;
my $doc = PDF::DOM.new;
my $page = $doc.add-page;
my $font = $page.core-font( :family<Helvetica> );

$page.text: -> $txt {
    my $para = q:to"--END--";
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
    ut labore et dolore magna aliqua.
    --END--
            
    $txt.set-font($font, :font-size(12));
    $txt.say( $para, :width(200), :height(150) :align<right>, :kern);
}
```

#### Forms and images (`.image` and  `.do` methods):

The `.image` method can be used to load an image and register it as a page resource.
The `.do` method can them be used to render it.

```
use PDF::DOM;
use PDF::DOM::Type::Catalog;
my $doc = PDF::DOM.new;
my $page = $doc.add-page;

$page.graphics: -> $gfx {
    my $img = $gfx.image("t/images/snoopy-happy-dance.jpg");
    $gfx.do($img, 150, 380, :width(150) );

    # displays the image again, semi-transparently with translation, rotation and scaling

    $gfx.transform( :translate[285, 250]);
    $gfx.transform( :rotate(-10), :scale(1.5) );
    $gfx.set-graphics( :transparency(.5) );
    $gfx.do($img, 300, 380, :width(150) );
}
```

Note: at this stage, only the `JPEG` image format is supported.

For a full description of `.set-graphics` options, please see PDF::DOM::Type::ExtGState.

### Text effects

To display card suits symbols, using the ZapfDingbats core-font. Diamond and hearts colored red:

```
use PDF::DOM;
my $doc = PDF::DOM.new;
my $page = $doc.add-page;

$page.graphics: -> $_ {

    $page.text: -> $txt {
	$txt.text-position = [240, 600];
	$txt.set-font( $page.core-font('ZapfDingbats'), 24);
	$txt.SetWordSpacing(16);
	my $nbsp = "\c[NO-BREAK SPACE]";
	$txt.print("♠ ♣$nbsp");
	$txt.SetFillRGB( 1, .3, .3);  # redish
	$txt.say("♦ ♥");
    }

    # Display outline, slanted text, using the ShowText (`Td`) operator:

    my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );

    $page.text: -> $_ {
	 use PDF::DOM::Op :TextMode;
	.set-font( $header-font, 12);
	.SetTextRender: TextMode::OutlineText;
	.SetLineWidth: .5;
	.text-transform( :translate[50, 550], :slant(12) );
	.ShowText('Outline Slanted Text @(50,550)');
    }
}

```

Note: at this stage, only the PDF core fonts are supported: Courier, Times, Helvetica, ZapfDingbats and Symbol.

#### Low level graphics, colors and drawing

PDF::DOM::Contents::Gfx inherits from PDF::DOM::Op, which implements the full range of PDF content operations:

```
use PDF::DOM;
my $doc = PDF::DOM.new;
my $page = $doc.add-page;

# Draw a simple Bézier curve:

# ------------------------
# Alternative 1: Using operator functions (see PDF::DOM::Op)
sub draw-curve1($gfx) {
    $gfx.Save;
    $gfx.MoveTo(175, 720);
    $gfx.LineTo(175, 700);
    $gfx.CurveTo1( 300, 800, 
                   400, 720 );
    $gfx.ClosePath;
    $gfx.Stroke;
    $gfx.Restore;
}

draw-curve1($page.gfx);

# ------------------------
# Alternative 2: draw from parsed content instructions:

sub draw-curve2($gfx) {
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
draw-curve2($doc.add-page.gfx);

# ------------------------
# Altrnative 3: draw from raw data
sub draw-curve3($gfx) {

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
draw-curve3($doc.add-page.gfx);

```

For a full list of operators, please see PDF::DOM::Op.

### AcroForm Fields

```
use PDF::DOM;
my $doc = PDF::DOM.open: "t/pdf/samples/OoPdfFormExample.pdf";
if my $acroform = $doc.Root.AcroForm {
    my @fields = $acroform.fields;
    # display field names and values
    for @fields -> $field {
        say "{$field.T // '??'}: {$field.V // ''}";
    }
}

```

See also:
- PDF::DOM::Type::AcroForm
- PDF::DOM::Type::Field
- PDF::FDF (under construction), which handles import/export from FDF files.

### Resources
To list all images and forms for each page
```
use PDF::DOM;
my $doc = PDF::DOM.open: "t/helloworld.pdf";
for 1 ... $doc.page-count -> $page-no {
    say "page: $page-no";
    my $page = $doc.page: $page-no;
    my %object = $page.resources('XObject');
    for %object.keys -> $key {
        my $xobject = %object{$key};
        my $type = $xobject.Type;
        my $size = $xobject.encoded.codes;
        say "\t$key: $type $size bytes"
    }
}

```

Resource types are: ExtGState (graphics state), ColorSpace, Pattern, Shading, XObject (forms and images) and Properties.

Resources of type Pattern and XObject/Image may have further associated resources.

## Development Status

The PDF::DOM module is under construction and not yet functionally complete.

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
- No structured exceptions yet.