[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::NameTree[PDF::Destination::DestNamed] $.Dests

(Optional; PDF 1.2) A name tree mapping name strings to destinations.

### has PDF::NameTree $.AP

(Optional; PDF 1.3) A name tree mapping name strings to annotation appearance streams.

### has PDF::NameTree $.JavaScript

(Optional; PDF 1.3) A name tree mapping name strings to document-level JavaScript actions.

### has PDF::NameTree $.Pages

(Optional; PDF 1.3) A name tree mapping name strings to visible pages for use in interactive forms.

### has PDF::NameTree $.Templates

(Optional; PDF 1.3) A name tree mapping name strings to invisible (template) pages for use in interactive forms.

### has PDF::NameTree $.IDS

(Optional; PDF 1.3) A name tree mapping digital identifiers to Web Capture content sets.

### has PDF::NameTree $.URLS

(Optional; PDF 1.3) A name tree mapping uniform resource locators (URLs) to Web Capture content sets10.4, "Content Sets").

### has PDF::NameTree[PDF::Filespec::FileRef] $.EmbeddedFiles

(Optional; PDF 1.4) A name tree mapping name strings to file specifications for embedded file streams.

### has PDF::NameTree $.AlternatePresentations

(Optional; PDF 1.4) A name tree mapping name strings to alternate presentations.

### has PDF::NameTree $.Renditions

(Optional; PDF 1.5) A name tree mapping name strings (which shall have Unicode encoding) to rendition objects.

