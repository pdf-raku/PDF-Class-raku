[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /Border

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, must be Border for a border style dictionary.

### has Numeric $.W

(Optional) The border width in points. If this value is 0, no border is drawn. Default value: 1.

### has PDF::Border::BorderStyleName $.S

(Optional) The border style: S(Solid) A solid rectangle surrounding the annotation. D(Dashed) A dashed rectangle surrounding the annotation. The dash pattern is specified by the D entry (see below). B(Beveled) A simulated embossed rectangle that appears to be raised above the surface of the page. I(Inset) A simulated engraved rectangle that appears to be recessed below the surface of the page. U(Underline) A single line along the bottom of the annotation rectangle. Other border styles may be defined in the future. Default value: S.

### has Positional[UInt] @.D

(Optional) A dash array defining a pattern of dashes and gaps to be used in drawing a dashed border (border style D above). The dash array is specified in the same format as in the line dash pattern parameter of the graphics state. The dash phase is not specified and is assumed to be 0. For example, a Dentry of [ 3 2 ] specifies a border drawn with 3-point dashes alternating with 2-point gaps. Default value: [ 3 ].

