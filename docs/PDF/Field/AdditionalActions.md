[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

Description
===========

Table 196 – Entries in a form field’s additional-actions dictionary

Methods (Entries)
=================

class PDF::Action $.K (change)
------------------------------

(Optional; PDF 1.3) A JavaScript action that is performed when the user modifies a character in a text field or combo box or modifies the selection in a scrollable list box. This action may check the added text for validity and reject or modify it.

class PDF::Action $.F (format)
------------------------------

(Optional; PDF 1.3) A JavaScript action that is performed before the field is formatted to display its value. This action may modify the field’s value before formatting.

class PDF::Action $.V (validate)
--------------------------------

(Optional; PDF 1.3) A JavaScript action that is performed when the field’s value is changed. This action may check the new value for validity.

class PDF::Action $.C (calculate)
---------------------------------

(Optional; PDF 1.3) A JavaScript action that is performed to recalculate the value of this field when that of another field changes. (The name C stands for “calculate.”) The order in which the document’s fields are recalculated is defined by the CO entry in the interactive form dictionary

