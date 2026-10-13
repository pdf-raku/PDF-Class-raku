[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /Encoding

### has PDF::COS::Name $.BaseEncoding

(Optional) The base encoding—that is, the encoding from which the Differences entry (if present) describes differences.

### has Positional @.Differences

(Optional; not recommended with TrueType fonts) An array describing the differences from the encoding specified by BaseEncoding or, if BaseEncoding is absent, from an implicit base encoding.

