use v6;

use PDF::Annot::Markup;

class PDF::Annot::Link
    is PDF::Annot::Markup {

    # See [PDF 1.7 TABLE 8.24 Additional entries specific to a link annotation]
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Action;
    use PDF::Destination :DestSpec, :coerce-dest;
    use PDF::Action::URI;
    use PDF::Border;

    has PDF::Action $.A is entry(:alias<action>);             #| (Optional; PDF 1.1) An action to be performed when the link annotation is activated.
    has DestSpec $.Dest is entry(:coerce(&coerce-dest));                     #| (Optional; not permitted if an A entry is present) A destination to be displayed when the annotation is activated
    my subset HName of PDF::COS::Name where 'N'|'I'|'O'|'P';
    has HName $.H is entry(:alias<highlight-mode>);           #| (Optional; PDF 1.2) The annotation’s highlighting mode, the visual effect to be used when the mouse button is pressed or held down inside its active area:
                                       #| N(None)    - No highlighting.
                                       #| I(Invert)  - Invert the contents of the annotation rectangle.
                                       #| O(Outline) - Invert the annotation’s border.
                                       #| P(Push)    - Display the annotation as if it were being pushed below the surface of the page;
                                       #| Default value: I.
    has PDF::Action::URI $.PA is entry(:alias<uri-action>);   #| (Optional; PDF 1.3) A URI action
    has Numeric @.QuadPoints is entry; #| (Optional; PDF 1.6) An array of 8 × n numbers specifying the coordinates of nquadrilaterals in default user space that comprise the region in which the link should be activated. The coordinates for each quadrilateral are given in the order: x1 y1 x2 y2 x3 y3 x4 y4, specifying the four vertices of the quadrilateral in counterclockwise order.

    has PDF::Border $.BS is entry; #| (Optional; PDF 1.6) A border style dictionary (see Table 166) specifying the line width and dash pattern to be used in drawing the annotation’s border. The annotation dictionary’s AP entry, if present, takes precedence over the BS entry

    method cb-check {
        die "A Link should not have both /A and Dest entries"
            if (self<A>:exists) && (self<Dest>:exists);
    }

}
