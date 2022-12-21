use v6;

#| /Type XObject /Subtype /Image
#| See [PDF 32000 Section 8.9 - Images ]
class PDF::XObject::Image {
    use PDF::XObject;
    use PDF::Image;

    also is PDF::XObject;
    also does PDF::Image;
}

=begin pod

=comment Adapted from [PDF ISO-32000 Section 8.9 Images]

PDF’s painting operators include general facilities for dealing with sampled images. A sampled image (or just
image for short) is a rectangular array of sample values, each representing a colour. The image may
approximate the appearance of some natural scene obtained through an input scanner or a video camera, or it
may be generated synthetically.

Note that this class does the following roles:

=item L<PDF::Image> - for low level manipulation of PDF Image objects.

=item L<PDF::Content>::Image - for high-level image loading.

The L<PDF::Content>::Image role enables PDF image objects to be loaded from image files. For example.

=begin code
my PDF::XObject::Image $logo .= load: "logo.png":
=end code


=end pod
