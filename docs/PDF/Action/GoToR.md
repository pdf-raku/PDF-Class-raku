[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::GoToR
------------------------

/Action Subtype - GoToR

### has PDF::Filespec::FileRef $.F

(Required) The file in which the destination shall be located.

### has PDF::Destination::RemoteDestRef $.D

(Required) The destination to jump to. If the value is an array defining an explicit destination, its first element shall be a page number within the remote document rather than an indirect reference to a page object in the current document. The first page shall be numbered 0.

### has PDF::Destination::RemoteDestRef $.SD

(Optional; PDF 2.0) The structure destination to jump to. The first element in the array is a byte string representing a structure element ID in the remote document, instead of an indirect reference to a structure element dictionary.

### has Bool $.NewWindow

(Optional; PDF 1.2) A flag specifying whether to open the destination document in a new window. If this flag is false, the destination document replaces the current document in the same window. If this entry is absent, the conforming reader should behave in accordance with its preference.

