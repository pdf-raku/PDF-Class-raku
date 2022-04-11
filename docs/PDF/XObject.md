[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::XObject
------------------

/Type /XObject - describes an abstract XObject. See also PDF::XObject::Form, PDF::XObject::Image

An external object (commonly called an `XObject`) is a graphics object whose contents are defined by a self- contained stream, separate from the content stream in which it is used. There are three types of external objects:

  * An image XObject [PDF::XObject::Image](https://pdf-raku.github.io/PDF-Class-raku) represents a sampled visual image such as a photograph.

  * A form XObject [PDF::Object::XObject::Form](https://pdf-raku.github.io/PDF-Class-raku) is a self-contained description of an arbitrary sequence of graphics objects.

  * A PostScript XObject [PDF::Object::PS](https://pdf-raku.github.io/PDF-Class-raku) contains a fragment of code expressed in the PostScript page description language. PostScript XObjects should not be used.

