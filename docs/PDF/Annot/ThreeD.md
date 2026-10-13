[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[Numeric] @.view-box

rectangle (Optional) The 3D view box, which is the rectangular area in which the 3D artwork shall be drawn. It shall be within the rectangle specified by the annotation’s Rect entry and shall be expressed in the annotation’s target coordinate system (see discussion following this Table). Default value: the annotation’s Rect entry, expressed in the target coordinate system. This value is [ -w/2 -h/2 w/2 h/2 ], where w and h are the width and height, respectively, of Rect.

### has Hash $.artwork

A 3D stream or 3D reference dictionary that specifies the 3D artwork to be shown.

### has Bool $.interactive

(Optional) A flag indicating the primary use of the 3D annotation. If true, it is intended to be interactive; if false, it is intended to be manipulated programmatically, as with a JavaScript animation. Conforming readers may present different user interface controls for interactive 3D annotations (for example, to rotate, pan, or zoom the artwork) than for those managed by a script or other mechanism. Default value: true.

### has Hash $.units

(Optional; PDF 2.0) A 3D units dictionary that specifies the units definitions for the 3D data associated with this annotation

### has Hash $.GEO

Optional; PDF 2.0) For Geospatial3D requirement type, a geospatial information section may be present as an attribute within a 3D Annotation.

