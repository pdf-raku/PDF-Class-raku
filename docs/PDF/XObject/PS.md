[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::XObject::PS
----------------------

Postscript XObjects /Type XObject /Subtype PS See [PDF 32000 Section 8.8.2 PostScript XObjects]

Beginning with PDF 1.1, a content stream may include PostScript language fragments. These fragments may be used only when printing to a PostScript output device; they have no effect either when viewing the document on-screen or when printing it to a non-PostScript device. In addition, conforming readers do not interpret the PostScript fragments. Hence, this capability should be used with extreme caution and only if there is no other way to achieve the same result. Inappropriate use of PostScript XObjects can cause PDF files to print incorrectly.

