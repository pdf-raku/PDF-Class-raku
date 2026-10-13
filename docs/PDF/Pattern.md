[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Pattern::PatternTypeInt $.PatternType

(Required) A code identifying the type of pattern that this dictionary describes; must be 1 for a tiling pattern, or 2 for a shading pattern.

### has Positional[Numeric] @.Matrix

(Optional) An array of six numbers specifying the pattern matrix. Default value: the identity matrix [ 1 0 0 1 0 0 ].

