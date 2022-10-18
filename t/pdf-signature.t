use Test;
plan 9;

use PDF::Class;
use PDF::AcroForm;
use PDF::Annot::Widget;
use PDF::Field::Signature;
use PDF::Annot::Widget;
use PDF::Signature;

my PDF::Class:D $pdf .= open: "t/pdf-signature.pdf";
my PDF::AcroForm:D $acroform = $pdf.catalog.AcroForm;
my PDF::Annot::Widget:D $sig-field = $acroform.Fields[0];
is $sig-field.FT, 'Sig';
is $sig-field.T, 'Test Signing Certificate-1-1081166692';
does-ok $sig-field, PDF::Field::Signature;
my PDF::Signature:D $sig = $sig-field.V;

is $sig.Type, 'Sig';
is $sig.ContactInfo, 'Contact info';
my @ranges = $sig.byte-ranges;
is-deeply @ranges, [0..18374, 43144..46016];
is $sig.Filter, 'Adobe.PPKLite';
is $sig.SubFilter, 'adbe.pkcs7.detached';
is $sig.Contents.substr(0,2), "0\x[82]";

