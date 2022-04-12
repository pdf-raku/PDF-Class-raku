[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

Description
===========

Table 196 – Entries in a form field’s additional-actions dictionary

Methods (Entries)
=================

### has PDF::Action $.K

(Optional; PDF 1.3) A JavaScript action that is performed when the user modifies a character in a text field or combo box or modifies the selection in a scrollable list box. This action may check the added text for validity and reject or modify it.

### has PDF::Action $.F

(Optional; PDF 1.3) A JavaScript action that is performed before the field is formatted to display its value. This action may modify the field’s value before formatting.

### has PDF::Action $.V

(Optional; PDF 1.3) A JavaScript action that is performed when the field’s value is changed. This action may check the new value for validity.

### has PDF::Action $.C

(Optional; PDF 1.3) A JavaScript action that is performed to recalculate the value of this field when that of another field changes. (The name C stands for “calculate.”) The order in which the document’s fields are recalculated is defined by the CO entry in the interactive form dictionary

