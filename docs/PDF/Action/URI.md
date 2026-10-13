[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::URI
----------------------

/Action Subtype - URI

### has PDF::Class::Defs::AsciiStr $.URI

(Required) The uniform resource identifier to resolve, encoded in 7-bit ASCII.

### has Bool $.IsMap

(Optional) A flag specifying whether to track the mouse position when the URI is resolved. Default value: false. This entry applies only to actions triggered by the user’s clicking an annotation; it shall be ignored for actions associated with outline items or with a document’s OpenAction entry.

