[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Function::Exponential
--------------------------------

/FunctionType 2 - Exponential

### has Positional[Numeric] @.C0

(Optional) An array of n numbers defining the function result when x = 0.0. Default value: [ 0.0 ].

### has Positional[Numeric] @.C1

(Optional) An array of n numbers defining the function result when x = 1.0. Default value: [ 1.0 ].

### has Numeric $.N

(Required) The interpolation exponent. Each input value x will return n values, given by yj = C0j + xN × (C1j − C0j ), for 0 ≤ j < n.

