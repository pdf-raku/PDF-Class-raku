# perl6-PDF-DOM

PDF::DOM is a Perl 6 module for the creation and manipulation of PDF files.

```
use v6;
use PDF::DOM;

my $pdf = PDF::DOM.new;
my $page = $pdf.add-page;
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

The PDF::DOM::Type namespace contains class librarys that map
internal data structures of PDF files including rules for coercement, type-checking and
serialization.

## Development Status

This module is under construction and not yet functionally complete. For progress
blogs see https://questhub.io/realm/perl/quest/54e66776070ccfd33800012a.
