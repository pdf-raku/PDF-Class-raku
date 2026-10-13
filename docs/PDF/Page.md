[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Page
---------------

/Type /Page - describes a single PDF page

### has PDF::Page::PagesLike $.Parent

(Required; must be an indirect reference) The page tree node that is the immediate parent of this page object.

### has Str $.LastModified

(Required if PieceInfo is present; optional otherwise; PDF 1.3) The date and time when the page’s contents were most recently modified

### has PDF::Resources $.Resources

(Required; inheritable) A dictionary containing any resources required by the page

### has Positional[Numeric] @.MediaBox

(Required; inheritable) A rectangle, expressed in default user space units, defining the boundaries of the physical medium on which the page is intended to be displayed or printed

### has Positional[Numeric] @.CropBox

Optional; inheritable) A rectangle, expressed in default user space units, defining the visible region of default user space. When the page is displayed or printed, its contents are to be clipped (cropped) to this rectangle and then imposed on the output medium in some implementation-defined manner

### has Positional[Numeric] @.BleedBox

(Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the region to which the contents of the page should be clipped when output in a production environment

### has Positional[Numeric] @.TrimBox

Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the intended dimensions of the finished page after trimming

### has Positional[Numeric] @.ArtBox

(Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the extent of the page’s meaningful content (including potential white space) as intended by the page’s creator

### has Hash $.BoxColorInfo

(Optional; PDF 1.4) A box color information dictionary specifying the colors and other visual characteristics to be used in displaying guidelines on the screen for the various page boundaries

### has Positional[PDF::COS::Stream] @.Contents

(Optional) A content stream describing the contents of this page. If this entry is absent, the page is empty

### has PDF::Page::NinetyDegreeAngle $.Rotate

(Optional; inheritable) The number of degrees by which the page should be rotated clockwise when displayed or printed



autoloaded PDF::Group::Transparency]

### has PDF::Page::TransparencyLike $.Group

(Optional; PDF 1.4) A group attributes dictionary specifying the attributes of the page’s page group for use in the transparent imaging model

### has PDF::Image $.Thumb

(Optional) A stream object defining the page’s thumbnail image

### has Positional[PDF::Bead] @.B

(Optional; PDF 1.1; recommended if the page contains article beads) An array of indirect references to article beads appearing on the page

### has Numeric $.Dur

(Optional; PDF 1.1) The page’s display duration (also called its advance timing): the maximum length of time, in seconds, that the page is displayed during presentations before the viewer application automatically advances to the next page

### has Hash $.Trans

(Optional; PDF 1.1) A transition dictionary describing the transition effect to be used when displaying the page during presentations

### has Positional[PDF::Page::AnnotLike] @.Annots

(Optional) An array of annotation dictionaries representing annotations associated with the page

### has PDF::Page::AdditionalActions $.AA

(Optional; PDF 1.2) An additional-actions dictionary defining actions to be performed when the page is opened or closed

### has PDF::Metadata::XML $.Metadata

(Optional; PDF 1.4) A metadata stream containing metadata for the page

### has Hash $.PieceInfo

(Optional; PDF 1.3) A page-piece dictionary associated with the page

### has UInt $.StructParents

(Required if the page contains structural content items; PDF 1.3) The integer key of the page’s entry in the structural parent tree

### has Str $.ID

(Optional; PDF 1.3; indirect reference preferred) The digital identifier of the page’s parent Web Capture content set

### has Numeric $.PZ

(Optional; PDF 1.3) The page’s preferred zoom (magnification) factor

### has PDF::Page::SeparationInfo $.SeparationInfo

(Optional; PDF 1.3) A separation dictionary containing information needed to generate color separations for the page

### has PDF::COS::Name $.Tabs

(Optional; PDF 1.5) A name specifying the tab order to be used for annotations on the page

### has PDF::COS::Name $.TemplateInstantiated

(Required if this page was created from a named page object; PDF 1.5) The name of the originating page object

### has Hash $.PresSteps

(Optional; PDF 1.5) A navigation node dictionary representing the first node on the page

### has Numeric $.UserUnit

(Optional; PDF 1.6) A positive number giving the size of default user space units, in multiples of 1 ⁄ 72 inch

### has Positional[Hash] @.VP

Optional; PDF 1.6) An array of viewport dictionaries

### has Positional[PDF::Filespec] @.AF

Optional; PDF 2.0) An array of one or more file specification dictionaries which denote the associated files for this page.

### has Positional[PDF::OutputIntent] @.OutputIntents

Optional; PDF 2.0) An array of output intent dictionaries that specify the colour characteristics of output devices on which this page might be rendered

### has Hash $.DPart

(Required, if this page is within the range of a DPart, not permitted otherwise; PDF 2.0) An indirect reference to the DPart dictionary whose range of pages includes this page object

