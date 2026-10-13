[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::XObject::Form
------------------------

XObject Forms - /Type /XObject /Subtype Form

### has <anon> $.FormType

(Optional) A code identifying the type of form XObject that this dictionary describes. The only valid value is 1.

### has Positional[Numeric] @.BBox

(Required) An array of four numbers in the form coordinate system (see above), giving the coordinates of the left, bottom, right, and top edges, respectively, of the form XObject’s bounding box.

### has Positional[Numeric] @.Matrix

(Optional) An array of six numbers specifying the form matrix, which maps form space into user space

### has PDF::Resources $.Resources

(Optional but strongly recommended; PDF 1.2) A dictionary specifying any resources (such as fonts and images) required by the form XObject

### has PDF::Group::Transparency $.Group

(Optional; PDF 1.4) A group attributes dictionary indicating that the contents of the form XObject are to be treated as a group and specifying the attributes of that group

### has Hash $.Ref

(Optional; PDF 1.4) A reference dictionary identifying a page to be imported from another PDF file, and for which the form XObject serves as a proxy

### has PDF::Metadata::XML $.Metadata

(Optional; PDF 1.4) A metadata stream containing metadata for the form XObject

### has Hash $.PieceInfo

(Optional; PDF 1.3) A page-piece dictionary associated with the form XObject

### has PDF::COS::DateString $.LastModified

(Required if PieceInfo is present; optional otherwise; PDF 1.3) The date and time when the form XObject’s contents were most recently modified

### has UInt $.StructParent

(Required if the form XObject is a structural content item; PDF 1.3) The integer key of the form XObject’s entry in the structural parent tree

### has UInt $.StructParents

(Required if the form XObject contains marked-content sequences that are structural content items; PDF 1.3) The integer key of the form XObject’s entry in the structural parent tree

### has Hash $.OPI

(Optional; PDF 1.2) An OPI version dictionary for the form XObject

### has PDF::Class::OptionalContent $.OC

(Optional; PDF 1.5) An optional content group or optional content membership dictionary

### has PDF::COS::Name $.Name

(Required in PDF 1.0; optional otherwise) The name by which this form XObject is referenced in the XObject subdictionary of the current resource dictionary.

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries dictionaries which denote the associated files for this form XObject.

### has PDF::COS::Dict $.Measure

(Optional; PDF 2.0) A measure dictionary that specifies the scale and units which apply to the form.

### has PDF::COS::Dict $.PtData

(Optional; PDF 2.0) A point data dictionary that specifies the extended geospatial data that apply to the form.

A form XObject is a PDF content stream that is a self-contained description of any sequence of graphics objects (including path objects, text objects, and sampled images). A form XObject may be painted multiple times—either on several pages or at several locations on the same page—and produces the same results each time, subject only to the graphics state at the time it is invoked. Not only is this shared definition economical to represent in the PDF file, but under suitable circumstances the conforming reader can optimize execution by caching the results of rendering the form XObject for repeated reuse.

