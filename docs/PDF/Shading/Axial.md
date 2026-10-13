[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Shading::Axial
-------------------------

/ShadingType 2 - Axial

### has Positional[Numeric] @.Coords

(Required) An array of four numbers [ x0 y0 x1 y1 ] specifying the starting and ending coordinates of the axis, expressed in the shading’s target coordinate space.

### has Positional[Numeric] @.Domain

(Optional) An array of two numbers [ t0 t1 ] specifying the limiting values of a parametric variable t. The variable is considered to vary linearly between these two values as the color gradient varies between the starting and ending points of the axis

### has Positional[PDF::Function] @.Function

(Required) A 1-in, n-out function or an array of n 1-in, 1-out functions (where nis the number of color components in the shading dictionary’s color space)

### has Positional[Bool] @.Extend

(Optional) An array of two boolean values specifying whether to extend the shading beyond the starting and ending points of the axis, respectively

