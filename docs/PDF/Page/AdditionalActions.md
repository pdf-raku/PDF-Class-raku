[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

Description
===========

Table 195 – Entries in a page object’s additional-actions dictionary

Methods (Entries)
=================

class PDF::Action $.O (page-open)
---------------------------------

(Optional; PDF 1.2) An action that is performed when the page is opened (for example, when the user navigates to it from the next or previous page or by means of a link annotation or outline item). This action is independent of any that may be defined by the OpenAction entry in the document Catalog (see 7.7.2, “Document Catalog”) and is executed after such an action.

class PDF::Action $.C (page-close)
----------------------------------

(Optional; PDF 1.2) An action that is performed when the page is closed (for example, when the user navigates to the next or previous page or follows a link annotation or an outline item). This action applies to the page being closed and is executed before any other page is opened.

