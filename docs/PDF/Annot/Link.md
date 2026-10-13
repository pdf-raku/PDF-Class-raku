[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Action $.A

(Optional; PDF 1.1) An action to be performed when the link annotation is activated.

### has PDF::Destination::DestRef $.Dest

(Optional; not permitted if an A entry is present) A destination to be displayed when the annotation is activated

### has PDF::Annot::Link::HighlightMode $.H

(Optional; PDF 1.2) The annotation’s highlighting mode, the visual effect to be used when the mouse button is pressed or held down inside its active area:

### has PDF::Action::URI $.PA

(Optional; PDF 1.3) A URI action

### has Positional[Numeric] @.QuadPoints

(Optional; PDF 1.6) An array of 8 × n numbers specifying the coordinates of nquadrilaterals in default user space that comprise the region in which the link should be activated. The coordinates for each quadrilateral are given in the order: x1 y1 x2 y2 x3 y3 x4 y4, specifying the four vertices of the quadrilateral in counterclockwise order.

### has PDF::Border $.BS

(Optional; PDF 1.6) A border style dictionary specifying the line width and dash pattern to be used in drawing the annotation’s border. The annotation dictionary’s AP entry, if present, takes precedence over the BS entry

