[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

Description
===========

Table 194 – Entries in an annotation’s additional-actions dictionary

Methods (Entries)
=================

class PDF::Action $.E (enter)
-----------------------------

(Optional; PDF 1.2) An action that is performed when the cursor enters the annotation’s active area.

class PDF::Action $.X (exit)
----------------------------

(Optional; PDF 1.2) An action that is performed when the cursor exits the annotation’s active area.

class PDF::Action $.D (mouse-down)
----------------------------------

(Optional; PDF 1.2) An action that is performed when the mouse button is pressed inside the annotation’s active area.

class PDF::Action $.U (mouse-up)
--------------------------------

(Optional; PDF 1.2) An action that is performed when the mouse button is released inside the annotation’s active area.

For backward compatibility, the A entry in an annotation dictionary, if present, takes precedence over this entry (see Table 168).

class PDF::Action $.Fo (focus)
------------------------------

(Optional; PDF 1.2; widget annotations only) An action that is performed when the annotation receives the input focus.

class PDF::Action $.Bl (blur)
-----------------------------

(Optional; PDF 1.2; widget annotations only) (Uppercase B, lowercase L) An action that is performed when the annotation loses the input focus.

class PDF::Action $.PO (page-open)
----------------------------------

(Optional; PDF 1.5) An action that is performed when the page containing the annotation is opened.

EXAMPLE 1 When the user navigates to it from the next or previous page or by means of a link annotation or outline item. The action is executed after the O action in the page’s additional-actions dictionary (see Table 195) and the OpenAction entry in the document Catalog (see Table 28), if such actions are present.

class PDF::Action $.PC (page-close)
-----------------------------------

(Optional; PDF 1.5) An action that is performed when the page containing the annotation is closed.

EXAMPLE 2 When the user navigates to the next or previous page, or follows a link annotation or outline item. The action is executed before the C action in the page’s additional-actions dictionary (see Table 195), if present.

This action is executed after the O action in the page’s additional-actions dictionary (and the OpenAction entry in the document Catalog, if such actions are present.

The action is executed before the C action in the page’s additional- actions dictionary (see Table 195), if present.

class PDF::Action $.PV (page-visable)
-------------------------------------

(Optional; PDF 1.5) An action that is performed when the page containing the annotation becomes visible.

class PDF::Action $.PI (page-invisable)
---------------------------------------

(Optional; PDF 1.5) An action that is performed when the page containing the annotation is no longer visible in the conforming reader’s user interface.

