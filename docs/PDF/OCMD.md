[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[PDF::OCG] @.OCGs

(Optional) A dictionary or array of dictionaries specifying the optional content groups whose states shall determine the visibility of content controlled by this membership dictionary. Null values or references to deleted objects shall be ignored. If this entry is not present, is an empty array, or contains references only to null or deleted objects, the membership dictionary shall have no effect on the visibility of any content.

### has <anon> $.P

(Optional) A name specifying the visibility policy for content belonging to this membership dictionary. Valid values shall be:

### has Positional @.VE

(Optional; PDF 1.6) An array specifying a visibility expression, used to compute visibility of content based on a set of optional content groups

