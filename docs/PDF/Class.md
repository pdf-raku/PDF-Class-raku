[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Class
----------------

PDF entry-point. either a trailer dict or an XRef stream

Synopsis
--------

```raku
use PDF::Class;
use PDF::Catalog;
use PDF::Page;
use PDF::Info;

my PDF::Class $pdf .= open: "t/helloworld.pdf";

# vivify Info entry; set title
given $pdf.Info //= {} -> PDF::Info $_ {
    .Title = 'Hello World!';
    .ModDate = DateTime.now; # PDF::Class sets this anyway...
}

# modify Viewer Preferences
my PDF::Catalog $catalog = $pdf.Root;
given $catalog.ViewerPreferences //= {} {
    .HideToolbar = True;
}

# add a page ...
my PDF::Page $new-page = $pdf.add-page;
$new-page.gfx.say: "New last page!";

# save the updated pdf
$pdf.save-as: "tmp/pdf-updated.pdf";
```

Description
-----------

This is the base class for opening or creating a document as a PDF class. the document can then be manipulated as a library of classes that represent the majority of objects that can be found in a PDF file.

