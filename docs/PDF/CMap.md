[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::CMap
---------------

/Type /CMap

### has PDF::COS::Name $.CMapName

(Required) The PostScript name of the CMap. It should be the same as the value of CMapName in the CMap file.

### has PDF::CIDSystemInfo $.CIDSystemInfo

(Required) A dictionary containing entries that define the character collection for the CIDFont or CIDFonts associated with the CMap

### has PDF::CMap::ZeroOrOne $.WMode

(Optional) A code that determines the writing mode for any CIDFont with which this CMap is combined. The possible values are 0 for horizontal and 1 for vertical

### has PDF::CMap::CMapRef $.UseCMap

(Optional) The name of a predefined CMap, or a stream containing a CMap, that is to be used as the base for this CMap

