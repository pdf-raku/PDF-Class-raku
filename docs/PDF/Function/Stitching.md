[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Function::Stitching
------------------------------

/FunctionType 3 - Stitching see [PDF 32000 Section 7.4.10 Type 3 (Stitching) Functions]

### has Positional @.Functions

(Required) An array of k 1-input functions making up the stitching function. The output dimensionality of all functions must be the same, and compatible with the value of Range if Range is present.

### has Positional[Numeric] @.Bounds

(Required) An array of k − 1 numbers that, in combination with Domain, define the intervals to which each function from the Functions array applies. Bounds elements must be in order of increasing value, and each value must be within the domain defined by Domain.

### has Positional[Numeric] @.Encode

(Required) An array of 2 × k numbers that, taken in pairs, map each subset of the domain defined by Domain and the Bounds array to the domain of the corresponding function.

