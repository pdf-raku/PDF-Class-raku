[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::COS::Name $.BaseFont

(Required) The PostScript name of the font. In principle, this is an arbitrary name, since there is no font program associated directly with a Type 0 font dictionary.

### has PDF::CMap::CMapRef $.Encoding

(Required) The name of a predefined CMap, or a stream containing a CMap that maps character codes to font numbers and CIDs.

### has Positional[PDF::Font::CIDFont] @.DescendantFonts

(Required) A one-element array specifying the CIDFont dictionary that is the descendant of this Type 0 font.

### has PDF::COS::Stream $.ToUnicode

(Optional) A stream containing a CMap file that maps character codes to Unicode values

