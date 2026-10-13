[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



Outline - an entry in the Outlines Dictionary See /First and /Last Accessors in PDF::Outlines

### has PDF::COS::TextString $.Title

(Required) The text to be displayed on the screen for this item.

### has PDF::Class::OutlineNode $.Parent

(Required; must be an indirect reference) The parent of this item in the outline hierarchy. The parent of a top-level item is the outline dictionary itself.

### has PDF::Outline $.Prev

(Required for all but the first item at each level; must be an indirect reference)The previous item at this outline level.

### has PDF::Outline $.Next

(Required for all but the last item at each level; must be an indirect reference)The next item at this outline level.

### has PDF::Outline $.First

(Required if the item has any descendants; must be an indirect reference) The first of this item’s immediate children in the outline hierarchy.

### has PDF::Outline $.Last

(Required if the item has any descendants; must be an indirect reference) The last of this item’s immediate children in the outline hierarchy.

### has Int $.Count

(Required if the item has any descendants) If the item is open, the total number of its open descendants at all lower levels of the outline hierarchy. If the item is closed, a negative integer whose absolute value specifies how many descendants would appear if the item were reopened.

### has PDF::Destination::DestRef $.Dest

(Optional; not permitted if an A entry is present) The destination to be displayed when this item is activated

### has PDF::Action $.A

(Optional; PDF 1.1; not permitted if a Dest entry is present) The action to be performed when this item is activated.

### has PDF::StructElem $.SE

(Optional; PDF 1.3; must be an indirect reference) The structure element to which the item refers.

