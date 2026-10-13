[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[Numeric] @.RD

(Optional; PDF 1.5) A set of four numbers describing the numerical differences between two rectangles: the Rect entry of the annotation and the actual boundaries of the underlying square or circle. Such a difference can occur in situations where a border effect (described by BE) causes the size of the Rect to increase beyond that of the square or circle. The four numbers correspond to the differences in default user space between the left, top, right, and bottom coordinates of Rect and those of the square or circle, respectively. Each value must be greater than or equal to 0. The sum of the top and bottom differences must be less than the height of Rect, and the sum of the left and right differences must be less than the width of Rect.

### has PDF::Annot::Caret::Symbol $.Sy

(Optional) A name specifying a symbol that shall be associated with the caret: P - A new paragraph symbol (¶) should be associated with thecaret. None - No symbol should be associated with the caret.

