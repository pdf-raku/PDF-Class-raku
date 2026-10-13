[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Pages
----------------

/Type /Pages - a node in the page tree

### has PDF::Pages $.Parent

(Required except in root node; must be an indirect reference) The page tree node that is the immediate parent of this one.

### has Positional[PDF::Content::PageNode] @.Kids

(Required) An array of indirect references to the immediate children of this node. The children may be page objects or other page tree nodes.

### has UInt $.Count

(Required) The number of leaf nodes (page objects) that are descendants of this node within the page tree.

### has <anon> $.Rotate

(Optional; inheritable) The number of degrees by which the page should be rotated clockwise when displayed or printed

### has Positional[Numeric] @.MediaBox

inheritable page properties
(Required; inheritable) A rectangle (see 7.9.5, "Rectangles"), expressed in default user space units, that define the boundaries of the physical medium on which the page is displayed or printed.

### has Positional[Numeric] @.CropBox

(Optional; Inheritable) A rectangle, expressed in default user space units, that define the visible region of default user space. When the page is displayed or printed, its contents are clipped (cropped) to this rectangle. Default value: the value of MediaBox.

