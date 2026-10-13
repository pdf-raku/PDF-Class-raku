[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Shading::Function
----------------------------

/ShadingType 1 - Functional

### has Positional[Numeric] @.Domain

(Optional) An array of four numbers [ xmin xmax ymin ymax ] specifying the rectangular domain of coordinates over which the color function(s) are defined.

### has Positional[Numeric] @.Matrix

(Optional) An array of six numbers specifying a transformation matrix mapping the coordinate space specified by the Domain entry into the shading’s target coordinate space.

### has Positional[PDF::Function] @.Function

(Required) A 2-in, n-out function or an array of n 2-in, 1-out functions (where nis the number of color components in the shading dictionary’s color space)

