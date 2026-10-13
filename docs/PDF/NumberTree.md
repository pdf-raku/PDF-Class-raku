[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[PDF::NumberTree] @.Kids

(Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Nums is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.

### has Positional @.Nums

Root and leaf nodes only; required in leaf nodes; present in the root node if and only if Kids is not present) An array of the form

### has Positional[Numeric] @.Limits

(Present in Intermediate and leaf nodes only) Shall be an array of two integers, that shall specify the (numerically) least and greatest keys included in the Nums array of a leaf node or in the Nums arrays of any leaf nodes that are descendants of an intermediate node.

