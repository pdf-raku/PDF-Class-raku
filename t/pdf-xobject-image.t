use v6;
use Test;

plan 22;

use PDF::Class;
use PDF::Class::Type;
use PDF::IO::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::XObject::Image;

my PDF::Grammar::PDF::Actions $actions .= new: :lite;

my $input = q:to"--END-OBJ--";
14 0 obj <<
  /Intent/RelativeColorimetric
  /Type/XObject
  /ColorSpace/DeviceGray
  /Subtype/Image
  /Name/X
  /Width 2988
  /BitsPerComponent 8
  /Length 13
  /Height 2286
  /Filter/DCTDecode
>> stream
(binary data)
endstream endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my %ast = $/.ast;
my PDF::IO::IndObj $ind-obj .= new( |%ast, :$input);
is $ind-obj.obj-num, 14, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $ximage-obj = $ind-obj.object;
isa-ok $ximage-obj, 'PDF::XObject::Image';
is $ximage-obj.Type, 'XObject', '$.Type accessor';
is $ximage-obj.Subtype, 'Image', '$.Subtype accessor';
is-json-equiv $ximage-obj.ColorSpace, 'DeviceGray', '$.ColorSpace accessor';
is-json-equiv $ximage-obj.BitsPerComponent, 8, '$.BitsPerComponent accessor';
is $ximage-obj.encoded, "(binary data)", '$.encoded accessor';

my $snoopy = PDF::XObject::Image.open("t/images/snoopy-happy-dance.jpg");
is $snoopy.Width, 200, '$img.Width (jpeg)';
is $snoopy.Height, 254, '$img.Height (jpeg)';
is $snoopy.ColorSpace, 'DeviceRGB', '$img.ColorSpace (jpeg)';
is $snoopy.BitsPerComponent, 8, '$img.BitsPerComponent (jpeg)';
is $snoopy.Length, $snoopy.encoded.chars, '$img Length (jpeg)';
lives-ok {$snoopy.check}, '$img.check lives';

my $inline = $snoopy.inline-content;
is +$inline, 3, '.content(:inline) has 3 ops';
is-json-equiv $inline[0], (:BI[ ]), 'first .content(:inline) op: :BI[...]';
is-json-equiv $inline[1], (:ID[ :dict{ BPC => 8,
                                       CS  => :name<DeviceRGB>,
                                       F   => :name<DCTDecode>,
                                       H   => 254,
                                       L   => 8247,
                                       W   => 200 },
                                :encoded($snoopy.encoded) ]), 'second .content(:inline) op: :ID[...]';
is-json-equiv $inline[2], (:EI[ ]), 'third .content(:inline) op: :EI[]';

my PDF::Class $pdf .= new;
my $page = $pdf.add-page;
$page.media-box = [0, 0, 220,220];
$page.gfx.comment('**Inline Image**');
$page.gfx.do($snoopy, 10, 15, :width(100), :height(190), :inline);
$page.gfx.comment('**Resourced Image**');
$page.gfx.do($snoopy, 120, 15, :width(90));
$page.gfx.do($snoopy, 120, 115, :width(90));

my @images = $page.images;
is +@images, 2, '$page.images';
my $image = @images.tail;
isa-ok $image, 'PDF::XObject::Image';
is-json-equiv $image, $snoopy, '$images dict';
is $image.encoded, $snoopy.encoded, '$images encoded';

$page = $pdf.add-page;

my $x = 50;

for <top center bottom> -> $valign {

    my $y = 170;

    for <left center right> -> $align {

        $page.gfx.do($snoopy, $x, $y, :width(40), :$align, :$valign);
        $y -= 60;
    }
    $x += 60;
}

# ensure consistant document ID generation
$pdf.id =  $*PROGRAM.basename.fmt('%-16.16s');

$pdf.save-as('t/pdf-xobject-image.pdf', :!info);
