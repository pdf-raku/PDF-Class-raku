[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



CalGray colour space dictionary

### has Positional[Numeric] @.WhitePoint

(Required) An array of three numbers [ XW YW ZW ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse white point. The numbers XW and ZW must be positive, and YW must be equal to 1.0.

### has Positional[Numeric] @.BlackPoint

(Optional) An array of three numbers [ XB YB ZB ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse black point. All three of these numbers must be non-negative. Default value: [ 0.0 0.0 0.0 ].

### has Numeric $.Gamma

(Optional) A number G defining the gamma for the gray (A) component. G must be positive and is generally greater than or equal to 1. Default value: 1.

