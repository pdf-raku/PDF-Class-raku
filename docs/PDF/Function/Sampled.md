[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Function::Sampled
----------------------------

/FunctionType 0 - Sampled see [PDF 32000 Section 7.10.2 Type 0 (Sampled) Functions]

### has Positional[UInt] @.Size

(Required) An array of m positive integers specifying the number of samples in each input dimension of the sample table.

### has PDF::Function::Sampled::Sample $.BitsPerSample

(Required) The number of bits used to represent each sample. (If the function has multiple output values, each one occupies BitsPerSample bits.) Valid values are 1, 2, 4, 8, 12, 16, 24, and 32.

### has PDF::Function::Sampled::OrderInt $.Order

(Optional) The order of interpolation between samples. Valid values are 1 and 3, specifying linear and cubic spline interpolation, respectively.

### has Positional[Numeric] @.Encode

(Optional) An array of 2 × m numbers specifying the linear mapping of input values into the domain of the function’s sample table. Default value: [ 0 (Size0 − 1) 0 (Size1 − 1) … ].

### has Positional[Numeric] @.Decode

(Optional) An array of 2 × n numbers specifying the linear mapping of sample values into the range appropriate for the function’s output values. Default value: same as the value of Range.

### method approximate

```raku
method approximate(
    @e
) returns Mu
```

Not proper n-linear interpolation. Just takes a weighted average of immediate neighours

