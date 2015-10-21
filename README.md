# perl6-PDF-DOM

PDF::DOM is a Perl 6 module for the creation and manipulation of PDF files.

It contains a class library that contains a detailed mapping of the interal
structure of PDF files including rules for coercement, type-checking and
serialization.

This module is under construction and not yet functionally complete. For progress
blogs see https://questhub.io/realm/perl/quest/54e66776070ccfd33800012a.

It is intended that PDF::DOM will evolve as a general purpose high-level PDF library.

```
use v6;
use PDF::DOM;

my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
my $font = $page.core-font( :family<Helvetica>, :weight<bold> );
$page.text: -> $txt {
    $txt.text-move(100,150, :abs);
    $txt.set-font: $font;
p    $txt.say: 'Hello, world!';
}
$pdf.Info = { :DateCreated( DateTime.now ) };
$pdf.save-as: "helloworld.pdf";
```

## Development Status

Under construction (not yet released to Perl 6 ecosystem)