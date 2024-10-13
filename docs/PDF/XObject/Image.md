[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::XObject::Image
-------------------------

/Type XObject /Subtype /Image See [PDF 32000 Section 8.9 - Images ]

PDF’s painting operators include general facilities for dealing with sampled images. A sampled image (or just image for short) is a rectangular array of sample values, each representing a colour. The image may approximate the appearance of some natural scene obtained through an input scanner or a video camera, or it may be generated synthetically.

Note that this class does the following roles:

  * [PDF::Image](https://pdf-raku.github.io/PDF-Class-raku) - for low level manipulation of PDF Image objects.

  * [PDF::Content](https://pdf-raku.github.io/PDF-Content-raku/PDF/Content)::Image - for high-level image loading.

The [PDF::Content](https://pdf-raku.github.io/PDF-Content-raku/PDF/Content)::Image role enables PDF image objects to be loaded from image files. For example.

    my PDF::XObject::Image $logo .= load: "logo.png":

