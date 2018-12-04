use v6;

use PDF::COS::Tie::Hash;

role PDF::Movie
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::Filespec :file-spec, :&to-file-spec;
    use PDF::XObject::Image;

    # See [PDF 32000 Table 295 - Entries in a movie dictionary]
    ## use ISO_32000::Movie;
    ## also does ISO_32000::Movie;

    has file-spec $.F is entry(:required, :alias<file-spec>, :coerce(&to-file-spec)); # (Required) A file specification identifying a self-describing movie file.
                # NOTE The format of a self-describing movie file is left unspecified, and there is no guarantee of portability.
    has Numeric @.Aspect is entry(:len(2)); # (Optional) The width and height of the movie’s bounding box, in pixels, and is specified as [ width height ]. This entry should be omitted for a movie consisting entirely of sound with no visible images.
    my subset NinetyDegreeAngle of Int where { $_ %% 90}
    has NinetyDegreeAngle $.Rotate is entry(:default(0)); # (Optional) The number of degrees by which the movie is rotated clockwise relative to the page. The value is a multiple of 90. Default value: 0.

    my subset BoolOrImage where Bool|PDF::XObject::Image;
    has BoolOrImage $.Poster is entry; # (Optional) A flag or stream specifying whether and how a poster image representing the movie is displayed. If this value is a stream, it shall contain an image XObject (see Link 8.9, “Images” ) to be displayed as the poster. If it is the boolean value true, the poster image is retrieved from the movie file; if it is false, no poster is displayed. Default value: false.
}
