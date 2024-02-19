#| XObject Forms - /Type /XObject /Subtype Form
unit class PDF::XObject::Form;
use PDF::XObject;
use PDF::Class::StructItem;
use PDF::Content::XObject;
use PDF::Content::Canvas;

also is PDF::XObject;
also does PDF::Class::StructItem;
also does PDF::Content::XObject['Form'];
also does PDF::Content::Canvas;

use ISO_32000::Table_95-Additional_Entries_Specific_to_a_Type_1_Form_Dictionary;
also does ISO_32000::Table_95-Additional_Entries_Specific_to_a_Type_1_Form_Dictionary;

use ISO_32000_2::Table_93-Additional_entries_specific_to_a_Type_1_form_dictionary;
also does ISO_32000_2::Table_93-Additional_entries_specific_to_a_Type_1_form_dictionary;

use PDF::COS::Tie;
use PDF::COS::DateString;
use PDF::COS::Stream;
use PDF::COS::Name;

use PDF::Filespec;
use PDF::Resources;
use PDF::Group::Transparency;
use PDF::Class::OptionalContent;

has Int $.FormType is entry where 1;               #= (Optional) A code identifying the type of form XObject that this dictionary describes. The only valid value is 1.
has Numeric @.BBox is entry(:required,:len(4));    #= (Required) An array of four numbers in the form coordinate system (see above), giving the coordinates of the left, bottom, right, and top edges, respectively, of the form XObject’s bounding box.
has Numeric @.Matrix is entry(:len(6));            #= (Optional) An array of six numbers specifying the form matrix, which maps form space into user space
has PDF::Resources $.Resources is entry;           #= (Optional but strongly recommended; PDF 1.2) A dictionary specifying any resources (such as fonts and images) required by the form XObject
has PDF::Group::Transparency $.Group is entry;     #= (Optional; PDF 1.4) A group attributes dictionary indicating that the contents of the form XObject are to be treated as a group and specifying the attributes of that group
has Hash $.Ref is entry;                           #= (Optional; PDF 1.4) A reference dictionary identifying a page to be imported from another PDF file, and for which the form XObject serves as a proxy
use PDF::Metadata::XML;
has PDF::Metadata::XML $.Metadata is entry;        #= (Optional; PDF 1.4) A metadata stream containing metadata for the form XObject
has Hash $.PieceInfo is entry;                     #= (Optional; PDF 1.3) A page-piece dictionary associated with the form XObject
has PDF::COS::DateString $.LastModified is entry;  #= (Required if PieceInfo is present; optional otherwise; PDF 1.3) The date and time when the form XObject’s contents were most recently modified
has UInt $.StructParent is entry;                  #= (Required if the form XObject is a structural content item; PDF 1.3) The integer key of the form XObject’s entry in the structural parent tree
has UInt $.StructParents is entry;                 #= (Required if the form XObject contains marked-content sequences that are structural content items; PDF 1.3) The integer key of the form XObject’s entry in the structural parent tree
method struct-parent { self.StructParents // self.StructParent }
has Hash $.OPI is entry;                           #= (Optional; PDF 1.2) An OPI version dictionary for the form XObject

has PDF::Class::OptionalContent $.OC is entry(:alias<optional-content-group>);         #= (Optional; PDF 1.5) An optional content group or optional content membership dictionary

has PDF::COS::Name $.Name is entry;                #= (Required in PDF 1.0; optional otherwise) The name by which this form XObject is referenced in the XObject subdictionary of the current resource dictionary.

has PDF::Filespec @.AF is entry;                   #= (Optional; PDF 2.0) An array of one or more file specification dictionaries dictionaries which denote the associated files for this form XObject.

has PDF::COS::Dict $.Measure is entry;             #= (Optional; PDF 2.0) A measure dictionary that specifies the scale and units which apply to the form.

has PDF::COS::Dict $.PtData is entry;              #= (Optional; PDF 2.0) A point data dictionary that specifies the extended geospatial data that apply to the form.  

method cb-check {
    die "only one of /StructParent or /StructParents should be present"
        if (self<StructParent>:exists) && (self<StructParents>:exists);
    die "/LastModified is required when /PieceInfo is present"
        if (self<PieceInfo>:exists) && !(self<LastModified>:exists);
}

=begin pod

=comment adapted from [PDF-32000 8.10 Form XObjects]

A form XObject is a PDF content stream that is a self-contained description of any sequence of graphics
objects (including path objects, text objects, and sampled images). A form XObject may be painted multiple
times—either on several pages or at several locations on the same page—and produces the same results each
time, subject only to the graphics state at the time it is invoked. Not only is this shared definition economical to
represent in the PDF file, but under suitable circumstances the conforming reader can optimize execution by
caching the results of rendering the form XObject for repeated reuse.

=end pod
