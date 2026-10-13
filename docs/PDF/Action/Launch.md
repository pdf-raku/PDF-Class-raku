[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::Launch
-------------------------

/Action Subtype - Launch

### has PDF::Filespec::FileRef $.F

(Required if none of the entries Win, Mac, or Unix is present) The application that shall be launched or the document that shall be opened or printed. If this entry is absent and the conforming reader does not understand any of the alternative entries, it shall do nothing.

### has Hash $.Win

(Optional) A dictionary containing parameters.

### has Mu $.Mac

(Optional) Mac OS–specific launch parameters; not yet defined.

### has Mu $.Unix

(Optional) UNIX-specific launch parameters; not yet defined.

### has Bool $.NewWindow

(Optional; PDF 1.2) A flag specifying whether to open the destination document in a new window. If this flag is false, the destination document replaces the current document in the same window. If this entry is absent, the conforming reader should behave in accordance with its current preference. This entry shall be ignored if the file designated by the F entry is not a PDF document.

