[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Border $.BS

(Optional) A border style dictionary specifying the line width and dash pattern to be used in drawing the rectangle or ellipse. Note: The annotation dictionary’s AP entry, if present, takes precedence over the Land BS entries

### has Positional[Numeric] @.IC

(Optional; PDF 1.4) An array of numbers in the range 0.0 to 1.0 specifying the interior color with which to fill the annotation’s rectangle or ellipse. The number of array elements determines the color space in which the color is defined:

### has Hash $.BE

(Optional; PDF 1.5) A border effect dictionary describing an effect applied to the border described by the BS entry

### has Positional[Numeric] @.RD

(Optional; PDF 1.5) A set of four numbers describing the numerical differences between two rectangles: the Rect entry of the annotation and the actual boundaries of the underlying square or circle. Such a difference can occur in situations where a border effect (described by BE) causes the size of the Rect to increase beyond that of the square or circle.

