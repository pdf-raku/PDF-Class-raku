[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::JavaScript
-----------------------------

/Action Subtype - JavaScript

### has PDF::Class::Defs::TextOrStream $.JS

(Required) A text string or text stream containing the JavaScript script to be executed. PDFDocEncoding or Unicode encoding (the latter identified by the Unicode prefix U+ FEFF) shall be used to encode the contents of thestring or stream.

