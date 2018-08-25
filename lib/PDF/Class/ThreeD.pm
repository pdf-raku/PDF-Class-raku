# Roles for PDF::Annot::ThreeD, PDF::Markup::Markup3D

use PDF::COS::Tie::Hash;

role PDF::Class::ThreeD
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 Table 298 – Additional entries specific to a 3D annotation]
    use PDF::COS::Tie;
    use PDF::COS::Dict;

    has Hash $.artwork is entry(:key<3DD>);      #| A 3D stream or 3D reference dictionary that specifies the 3D artwork to be shown.
    has $.default-view is entry(:key<3DV>);      #| (Optional) An object that specifies the default initial view of the 3D artwork that shall be used when the annotation is activated. It may be either a 3D view dictionary or one of the following types:
    #| • An integer specifying an index into the VA array.
    #| • A text string matching the IN entry in one of the views in the VA array.
    #| • A name that indicates the first (F), last (L), or default (D) entries in the VA array.

    has PDF::COS::Dict $.activation is entry(:key<3DA>);   #| dictionary (Optional) An activation dictionary that defines the times at which the annotation shall be activated and deactivated and the state of the 3D artwork instance at those times.
    has Bool $.interactive is entry(:key<3DI>, :default(True));  #| (Optional) A flag indicating the primary use of the 3D annotation. If true, it is intended to be interactive; if false, it is intended to be manipulated programmatically, as with a JavaScript animation. Conforming readers may present different user interface controls for interactive 3D annotations (for example, to rotate, pan, or zoom the artwork) than for those managed by a script or other mechanism. Default value: true.
    has Numeric @.view-box  is entry(:key<3DB>, :len(4)); #| rectangle (Optional) The 3D view box, which is the rectangular area in which the 3D artwork shall be drawn. It shall be within the rectangle specified by the annotation’s Rect entry and shall be expressed in the annotation’s target coordinate system (see discussion following this Table).
    #| Default value: the annotation’s Rect entry, expressed in the target
    #| coordinate system. This value is [ -w/2 -h/2 w/2 h/2 ], where w and h are the width and height, respectively, of Rect.
}
