[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Shading::Coons
-------------------------

/ShadingType 6 - Coons

### has UInt $.BitsPerCoordinate

(Required) The number of bits used to represent each vertex coordinate. Valid values are 1, 2, 4, 8, 12, 16, 24, and 32.

### has UInt $.BitsPerComponent

(Required) The number of bits used to represent each color component. Valid values are 1, 2, 4, 8, 12, and 16.

### has UInt $.BitsPerFlag

(Required) The number of bits used to represent the edge flag for each vertex (see below). Valid values of BitsPerFlag are 2, 4, and 8, but only the least significant 2 bits in each flag value are used

### has Positional[Numeric] @.Decode

(Required) An array of numbers specifying how to map vertex coordinates and color components into the appropriate ranges of values

### has Positional[PDF::Function] @.Function

(Optional) A 1-in, n-out function or an array of n 1-in, 1-out functions (where n is the number of color components in the shading dictionary’s color space).

