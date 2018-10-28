# Roles for PDF::Annot::ThreeD, PDF::ExData::Markup3D

use PDF::COS::Tie::Hash;

role PDF::Class::ThreeD
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Dict;

    has $.default-view is entry(:key<3DV>);      #| (Optional) An object that specifies the default initial view of the 3D artwork that shall be used when the annotation is activated. It may be either a 3D view dictionary or one of the following types:
    #| • An integer specifying an index into the VA array.
    #| • A text string matching the IN entry in one of the views in the VA array.
    #| • A name that indicates the first (F), last (L), or default (D) entries in the VA array.

    has PDF::COS::Dict $.activation is entry(:key<3DA>);   #| dictionary (Optional) An activation dictionary that defines the times at which the annotation shall be activated and deactivated and the state of the 3D artwork instance at those times.
}
