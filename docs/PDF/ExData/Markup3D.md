[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has <anon> $.Type

The type of PDF object that this dictionary describes; if present, is ExData for an external data dictionary.

### has <anon> $.Subtype

Required) The type of external data that this dictionary describes; shall be Markup3D for a 3D comment. The only defined value is Markup3D.

### has Str $.MD5

(Optional) A 16-byte string that contains the checksum of the bytes of the 3D stream data that this 3D comment is associated with. The checksum is calculated by applying the standard MD5 message-digest algorithm to the bytes of the stream data. This value is used to determine if artwork data has changed since this 3D comment was created.

