[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::OBJR
---------------

/Type /OBJR - Object Reference dictionary

### has PDF::Page $.Pg

(Optional; must be an indirect reference) The page object representing the page on which the object is rendered. This entry overrides any Pg entry in the structure element containing the object reference; it is required if the structure element has no such entry.

### has PDF::Class::StructItem $.Obj

(Required; must be an indirect reference) The referenced object.

