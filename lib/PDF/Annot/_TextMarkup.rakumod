#| /Type Annot - Annotation subtypes
#| See [PDF 32000 Section 12.5 Annotations]
class PDF::Annot::_TextMarkup {
    use PDF::Annot::_Markup;
    also is PDF::Annot::_Markup;
    
    use PDF::COS::Tie;
    has Numeric @.QuadPoints is entry(:required); # An array of 8 × n numbers specifying the coordinates of n quadrilaterals in default user space. Each quadrilateral encompasses a word or group of contiguous words in the text underlying the annotation. The coordinates for each quadrilateral are given  in the order x1 y1 x2 y2 x3 y3 x4 y4
}
