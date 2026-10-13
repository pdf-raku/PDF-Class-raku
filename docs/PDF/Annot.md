[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Annot
----------------

/Type /Annot Annotations

### has PDF::COS::Name $.FT

Include this, just to help discover if we're a field

### has Positional[Numeric] @.Rect

(Required) The annotation rectangle, defining the location of the annotation on the page in default user space units.

### has PDF::COS::TextString $.Contents

(Optional) Text to be displayed for the annotation or, if this type of annotation does not display text, an alternate description of the annotation’s contents in human-readable form

### has PDF::Page $.P

(Optional; PDF 1.3; not used in FDF files) An indirect reference to the page object with which this annotation is associated.

### has PDF::COS::TextString $.NM

(Optional; PDF 1.4) The annotation name, a text string uniquely identifying it among all the annotations on its page.

### has PDF::Annot::ModTime $.M

(Optional; PDF 1.1) The date and time when the annotation was most recently modified. The preferred format is a date string, but viewer applications should be prepared to accept and display a string in any format. See [ISO-32000 Table 165 - Annotation flags]

### has PDF::Annot::AnnotFlagsInt $.F

(Optional; PDF 1.1) A set of flags specifying various characteristics of the annotation

### has PDF::Appearance $.AP

(Optional; PDF 1.2) An appearance dictionary specifying how the annotation is presented visually on the page

### has PDF::COS::Name $.AS

(Required if the appearance dictionary AP contains one or more subdictionaries; PDF 1.2) The annotation’s appearance state, which selects the applicable appearance stream from an appearance subdictionary

### has PDF::Annot::Border $.Border

(Optional) An array specifying the characteristics of the annotation’s border. The border is specified as a rounded rectangle.

### has Positional[Numeric] @.C

(Optional; PDF 1.1) An array of numbers in the range 0.0 to 1.0, representing a color used for (*) background, when closed, (*) title bar of pop-up window, (*) link border

### has UInt $.StructParent

(Required if the annotation is a structural content item; PDF 1.3) The integer key of the annotation’s entry in the structural parent tree

### has PDF::Class::OptionalContent $.OC

(Optional; PDF 1.5) An optional content group or optional content membership dictionary specifying the optional content properties for the annotation.

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries, which denote the associated files for this annotation).

### has Numeric $.ca

(Optional; PDF 2.0) When regenerating the annotation's appearance stream, this is the opacity value that is used for all nonstroking operations on all visible elements of the annotation in its closed state (including its background and border) but not the popup window that appears when the annotation is opened.

### has Numeric $.CA

(Optional; PDF 1.4, PDF 2.0 for non-markup annotations) When regenerating the annotation's appearance stream, this is the opacity value that is used for stroking all visible elements of the annotation in its closed state, including its background and border, but not the popup window that appears when the annotation is opened.

### has PDF::Class::Defs::BlendMode $.BM

(Optional; PDF 2.0)  The blend mode that shall be used when painting the annotation onto the page (see 11.3.5, "Blend Mode" and 11.6.3, "Specifying Blending Colour Space and Blend Mode"). If this key is not present, blending shall take place using the Normal blend mode.

### has PDF::COS::TextString $.Lang

(Optional; PDF 2.0) A language identifier overriding the document’s language identifier to specify the natural language for all text in the annotation except where overridden by other explicit language specifications

### has Hash $.DR

In PDF 1.2, an additional entry in the field dictionary, DR, was defined but was never implemented. Beginning with PDF 1.5, this entry is obsolete and should be ignored.

