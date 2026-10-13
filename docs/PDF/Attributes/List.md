[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



Standard list attribute

### has PDF::Attributes::List::Numbering $.ListNumbering

(Optional; inheritable) The numbering system used to generate the content of the Lbl (Label) elements in an autonumbered list, or the symbol used to identify each item in an unnumbered list. The value of the ListNumbering is one of the following, and is applied as described here.

### has Bool $.ContinuedList

(Optional; PDF 2.0) A flag specifying whether the list is a continuation of a previous list in the structure tree

### has PDF::COS::ByteString $.ContinuedFrom

(Optional; PDF 2.0) The ID of the list for which this list is a continuation.

