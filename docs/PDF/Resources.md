[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



Resource Dictionary

### has Associative[Hash] %.ExtGState

(Optional) A dictionary that maps resource names to graphics state parameter dictionaries

### has Associative[PDF::Class::Defs::ColorSpace] %.ColorSpace

(Optional) A dictionary that maps each resource name to either the name of a device-dependent color space or an array describing a color space

### has Associative[PDF::Resources::PatternLike] %.Pattern

(Optional) A dictionary that maps resource names to pattern objects

### has Associative[PDF::Resources::ShadingLike] %.Shading

(Optional; PDF 1.3) A dictionary that maps resource names to shading dictionaries

### has Associative[PDF::Resources::XObjectLike] %.XObject

(Optional) A dictionary that maps resource names to external objects

### has Associative[PDF::Resources::FontLike] %.Font

(Optional) A dictionary that maps resource names to font dictionaries

### has Positional[PDF::COS::Name] @.ProcSet

(Optional) An array of predefined procedure set names

### has Associative[Hash] %.Properties

(Optional; PDF 1.2) A dictionary that maps resource names to property list dictionaries for marked content

