use Test;
plan 3;

use PDF::Class;
use PDF::Catalog;
use PDF::Names;
use PDF::NameTree;
use PDF::Filespec;
use PDF::EmbeddedFile;
use PDF::Image;
use PDF::COS::Stream;

my PDF::Class $pdf .= open: "t/pdf/samples/embedded-files.pdf";

my PDF::Catalog:D $catalog = $pdf.catalog;
my PDF::Names:D $names = $catalog.Names;
my PDF::NameTree:D $embedded-files = $names.EmbeddedFiles;
my PDF::Filespec:D $file = $embedded-files.name-tree<t/images/lightbulb.gif>;

is $file.file-name, 't/images/lightbulb.gif', 'file-name';

my PDF::EmbeddedFile:D $ef = $file.EF<F>;
my UInt:D $size = $ef.Params.Size;
is $ef.decoded.bytes, $size, 'embedded file size';

my PDF::COS::Stream() $img = { :decoded<xxx>, :dict{} }; 

$file.Thumb = $img;

does-ok $img, PDF::Image, 'Thumb coercion';