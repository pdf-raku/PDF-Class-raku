[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Page $.Pg

(Optional; shall be an indirect reference) The page object representing the page on which the graphics objects in the marked-content sequence shall be rendered. This entry overrides any Pg entry in the structure element containing the marked-content reference; it shall be required if the structure element has no such entry.

### has PDF::COS::Stream $.Stm

(Optional; shall be an indirect reference) The content stream containing the marked-content sequence. This entry should be present only if the marked-content sequence resides in a content stream other than the content stream for the page. If this entry is absent, the marked-content sequence shall be contained in the content stream of the page identified by Pg (either in the marked-content reference dictionary or in the parent structure element).

### has Mu $.StmOwn

(Optional; shall be an indirect reference) The PDF object owning the stream identified by Stems annotation to which an appearance stream belongs.

### has UInt $.MCID

(Required) The marked-content identifier sequence within its content stream.

