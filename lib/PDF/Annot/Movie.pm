use v6;

use PDF::Annot;

class PDF::Annot::Movie
    is PDF::Annot {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;
    use PDF::Movie;
    use PDF::MovieActivation;

    # See [PDF 32000 Table 186 - Additional entries specific a movie annotation]
    ## use ISO_32000::Movie_annotation_additional;
    ## also does ISO_32000::Movie_annotation_additional;

    has PDF::COS::TextString $.T is entry(:alias<title>); # (Optional) The title of the movie annotation. Movie actions may use this title to reference the movie annotation.

    has PDF::Movie $.Movie is entry(:required); # (Required) A movie dictionary that shall describe the movie’s static characteristics

    my subset MovieActivationOrBool where PDF::MovieActivation|Bool;
    multi sub coerce-action(Hash $movie-action, MovieActivationOrBool) {
        PDF::COS.coerce( $movie-action, PDF::MovieActivation);
    }
    multi sub coerce-action($_, MovieActivationOrBool) is default {
        fail "expected a movie activation dict or flag, got: {.perl}";
    }
    has MovieActivationOrBool $.A is entry(:alias<action>, :default, :coerce(&coerce-action)); # (Optional) A flag or dictionary specifying whether and how to play the movie when the annotation is activated. If this value is a dictionary, it is a movie activation dictionary (see Link 13.4, “Movies” ) specifying how to play the movie. If the value is the boolean true, the movie is played using default activation parameters. If the value is false, the movie shall not be played. Default value: true.
}
