[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



an entry in the StructTree See also PDF::StructTreeRoot

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be StructElem for a structure element.

### has PDF::COS::Name $.S

(Required) The structure type, a name object identifying the nature of the structure element and its role within the document, such as a chapter, paragraph, or footnote

### has Str $.ID

(Optional) The element identifier, a byte string designating this structure element. The string shall be unique among all elements in the document’s structure hierarchy. The IDTree entry in the structure tree root defines the correspondence between element identifiers and the structure elements they denote.

### has Positional[PDF::StructElem] @.Ref

Optional; PDF 2.0) An array containing zero, one or more indirect references to structure elements. A Ref identifies the structure element or elements to which the item of content, contained within this structure element, refers (e.g. footnotes, endnotes, sidebars, etc.).

### has PDF::Page $.Pg

(Optional; shall be an indirect reference) A page object representing a page on which some or all of the content items designated by the K entry shall be rendered.

### has PDF::StructElem::StructElemParent $.P

(Required; shall be an indirect reference) The structure element that is the immediate parent of this one in the structure hierarchy.

### has Positional[PDF::StructElem::StructElemChild] @.K

(Optional) The children of this structure element. The value of this entry may be one of the following objects or an array consisting of one or more of the following objects:

### has Positional[PDF::StructElem::AttributesOrRev] @.A

(Optional) A single attribute object or array of attribute objects associated with this structure element. Each attribute object shall be either a dictionary or a stream. If the value of this entry is an array, each attribute object in the array may be followed by an integer representing its revision number.

### has Positional[PDF::COS::Name] @.C

(Optional) An attribute class name or array of class names associated with this structure element. If the value of this entry is an array, each class name in the array may be followed by an integer representing its revision number.

### has UInt $.R

(Optional) The current revision number of this structure element. The value shall be a non-negative integer. Default value: 0.

### has PDF::COS::TextString $.T

(Optional) The title of the structure element, a text string representing it in human-readable form. The title should characterize the specific structure element, such as 'Chapter 1', rather than merely a generic element type, such as 'Chapter'.

### has PDF::COS::TextString $.Lang

(Optional; PDF 1.4) A language identifier specifying the natural language for all text in the structure element except where overridden by language specifications for nested structure elements or marked content. If this entry is absent, the language (if any) specified in the document catalogue applies.

### has PDF::COS::TextString $.Alt

(Optional) An alternate description of the structure element and its children in human-readable form, which is useful when extracting the document’s contents in support of accessibility to users with.

### has PDF::COS::TextString $.E

(Optional; PDF 1.5) The expanded form of an abbreviation.

### has PDF::COS::TextString $.ActualText

(Optional; PDF 1.4) Text that is an exact replacement for the structure element and its children. This replacement text (which should apply to as small a piece of content as possible) is useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries (7.11.3, "File specification dictionaries") which denote the associated files for the entire structure tree.

### has PDF::Namespace $.NS

Optional; PDF 2.0) An indirect reference to a namespace dictionary defining the namespace this element belongs to

### has PDF::StructElem::PhoneticAlphabet $.PhoneticAlphabet

(Optional; PDF 2.0) Property for a structure element that indicates the phonetic alphabet used by a Phoneme property. Applies to the structure element and its children, except where overridden by a child structure element.

### has PDF::COS::TextString $.Phoneme

(Optional; PDF 2.0) Property for a structure element that may be used as pronunciation hint. It is an exact replacement for content enclosed by the structure element and its children.

