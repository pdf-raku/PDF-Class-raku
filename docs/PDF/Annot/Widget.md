[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Annot::Widget::HName $.H

(Optional; PDF 1.2) The annotation’s highlighting mode, the visual effect to be used when the mouse button is pressed or held down inside its active area:

### has PDF::Action $.A

(Optional; PDF 1.1) An action to be performed when the link annotation is activated.

### has PDF::Annot::AdditionalActions $.AA

(Optional; PDF 1.2) An additional-actions dictionary defining the annotation’s behavior in response to various trigger events (see Section 8.5.2, “Trigger Events”).

### has PDF::Border $.BS

(Optional; PDF 1.2) A border style dictionary specifying the width and dash pattern to be used in drawing the annotation’s border. Note: The annotation dictionary’s AP entry, if present, takes precedence over the Land BS entries

### has PDF::Field $.Parent

(Required if this widget annotation is one of multiple children in a field; absent otherwise) An indirect reference to the widget annotation’s parent field. A widget annotation may have at most one parent; that is, it can be included in the Kids array of at most one field

