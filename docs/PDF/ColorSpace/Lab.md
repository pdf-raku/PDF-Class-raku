[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[Numeric] @.WhitePoint

(Required) An array of three numbers [ XW YW ZW ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse white point; see “CalRGB Color Spaces” on page 247 for further discussion. The numbers XW and ZW must be positive, and YWmust be equal to 1.0.

### has Positional[Numeric] @.BlackPoint

the CIE 1931 XYZ space, of the diffuse black point; see “CalRGB Color Spaces” on page 247 for further discussion. All three of these numbers must be non-negative. Default value: [ 0.0 0.0 0.0 ].

### has Positional[Numeric] @.Range

(Optional) An array of four numbers [ amin amax bmin bmax ] specifying the range of valid values for the a* and b* (B and C) components of the color. Component values falling outside the specified range are adjusted to the nearest valid value without error indication. Default value: [ −100 100 −100 100 ].

