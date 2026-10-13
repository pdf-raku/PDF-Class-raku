[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has <anon> $.Type

[name] (Optional) The type of PDF object that this dictionary describes; if present, is Bead for a bead dictionary.

### has PDF::Thread $.T

[dictionary] (Required for the first bead of a thread; optional for all others; is an indirect reference) The thread to which this bead belongs. (PDF 1.1) This entry is permitted only for the first bead of a thread. (PDF 1.2) It is permitted for any bead but required only for the first.

### has PDF::Bead $.N

[dictionary] (Required; is an indirect reference) The next bead in the thread. In the last bead, this entry shall refer to the first bead.

### has PDF::Bead $.V

[dictionary] (Required; is an indirect reference) The previous bead in the thread. In the first bead, this entry shall refer to the last bead.



autoloaded PDF::Page

### has PDF::Bead::PageLike $.P

[dictionary] (Required; is an indirect reference) The page object representing the page on which this bead appears.

### has Positional[Numeric] @.R

[rectangle] (Required) A rectangle specifying the location of this bead on the page.

### has <anon> $.Type

[name] (Optional) The type of PDF object that this dictionary describes; if present, is Thread for a thread dictionary.

### has PDF::Bead $.F

[dictionary] (Required; is an indirect reference) The first bead in the thread.

### has PDF::Info $.I

[dictionary] (Optional) A thread information dictionary containing information about the thread, such as its title, author, and creation date. The contents of this dictionary shall conform to the syntax for the document information dictionary (see Link 14.3.3, “Document Information Dictionary” ).

### has PDF::Metadata::XML $.Metadata

[stream] (Optional; PDF 2.0; is an indirect reference) A metadata stream containing information about the thread, such as its title, author, and creation date (see 14.3.2, "Metadata streams")

