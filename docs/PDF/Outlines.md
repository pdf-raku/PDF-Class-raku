[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /Outlines - the Outlines dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be Outlines for an outline dictionary.

### has PDF::Outline $.First

(Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the first top-level item in the outline.

### has PDF::Outline $.Last

(Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the last top-level item in the outline.

### has Int $.Count

(Required if the document has any open outline entries) The total number of open items at all levels of the outline. This entry should be omitted if there are no open outline items.

