[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Shading::Lattice
---------------------------

/ShadingType 5 - Lattice

### has UInt $.BitsPerCoordinate

[integer] (Required) The number of bits used to represent each vertex coordinate. The value is 1, 2, 4, 8, 12, 16, 24, or 32.

### has UInt $.BitsPerComponent

(Required) The number of bits used to represent each color component. Valid values are 1, 2, 4, 8, 12, and 16.

### has UInt $.VerticesPerRow

(Required) The number of vertices in each row of the lattice; the value must be greater than or equal to 2.

### has Positional[Numeric] @.Decode

(Required) An array of numbers specifying how to map vertex coordinates and color components into the appropriate ranges of values

### has Positional[PDF::Function] @.Function

(Optional) A 1-in, n-out function or an array of n 1-in, 1-out functions (where n is the number of color components in the shading dictionary’s color space).

