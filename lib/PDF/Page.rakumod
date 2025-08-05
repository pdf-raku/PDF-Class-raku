#| /Type /Page - describes a single PDF page
unit class PDF::Page;

use PDF::Lite;
use PDF::Class::Type;

also is PDF::Lite::Page;
also does PDF::Class::Type;

use PDF::Class::FieldContainer;
also does PDF::Class::FieldContainer;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::COS::Stream;

use PDF::Bead-Thread; # Declares PDF::Bead & PDF::Thread
use PDF::Field;
use PDF::Filespec;
use PDF::Image;
use PDF::OutputIntent;
use PDF::Page::AdditionalActions;
use PDF::Resources;

use ISO_32000::Table_30-Entries_in_a_page_object;
also does ISO_32000::Table_30-Entries_in_a_page_object;

use ISO_32000_2::Table_31-Entries_in_a_page_object;
also does ISO_32000_2::Table_31-Entries_in_a_page_object;

has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Page';
my subset PagesLike of Hash where .<Type> ~~ 'Pages'; # autoloaded PDF::Pages
has PagesLike $.Parent is entry(:indirect);       # (Required; must be an indirect reference) The page tree node that is the immediate parent of this page object.
has Str $.LastModified is entry;             # (Required if PieceInfo is present; optional otherwise; PDF 1.3) The date and time when the page’s contents were most recently modified
has PDF::Resources $.Resources is entry(:inherit);   # (Required; inheritable) A dictionary containing any resources required by the page
has Numeric @.MediaBox is entry(:inherit,:len(4));   # (Required; inheritable) A rectangle, expressed in default user space units, defining the boundaries of the physical medium on which the page is intended to be displayed or printed
has Numeric @.CropBox is entry(:inherit,:len(4));    # Optional; inheritable) A rectangle, expressed in default user space units, defining the visible region of default user space. When the page is displayed or printed, its contents are to be clipped (cropped) to this rectangle and then imposed on the output medium in some implementation-defined manner
has Numeric @.BleedBox is entry(:len(4));    # (Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the region to which the contents of the page should be clipped when output in a production environment
has Numeric @.TrimBox is entry(:len(4));     # Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the intended dimensions of the finished page after trimming
has Numeric @.ArtBox is entry(:len(4));      # (Optional; PDF 1.3) A rectangle, expressed in default user space units, defining the extent of the page’s meaningful content (including potential white space) as intended by the page’s creator
has Hash $.BoxColorInfo is entry;            # (Optional; PDF 1.4) A box color information dictionary specifying the colors and other visual characteristics to be used in displaying guidelines on the screen for the various page boundaries
has PDF::COS::Stream @.Contents is entry(:array-or-item);   # (Optional) A content stream describing the contents of this page. If this entry is absent, the page is empty
subset NinetyDegreeAngle of Int where { $_ %% 90}
has NinetyDegreeAngle $.Rotate is entry(:inherit, :alias<rotate>);     # (Optional; inheritable) The number of degrees by which the page should be rotated clockwise when displayed or printed
my subset TransparencyLike of Hash where .<S> ~~ 'Transparency'; # autoloaded PDF::Group::Transparency]
has TransparencyLike $.Group is entry;                      # (Optional; PDF 1.4) A group attributes dictionary specifying the attributes of the page’s page group for use in the transparent imaging model
has PDF::Image $.Thumb is entry(:alias<thumbnail-image>);   # (Optional) A stream object defining the page’s thumbnail image
has PDF::Bead @.B is entry(:indirect, :alias<beads>);       # (Optional; PDF 1.1; recommended if the page contains article beads) An array of indirect references to article beads appearing on the page
has Numeric $.Dur is entry(:alias<display-duration>);       # (Optional; PDF 1.1) The page’s display duration (also called its advance timing): the maximum length of time, in seconds, that the page is displayed during presentations before the viewer application automatically advances to the next page
has Hash $.Trans is entry(:alias<transition-effect>);       # (Optional; PDF 1.1) A transition dictionary describing the transition effect to be used when displaying the page during presentations
my subset AnnotLike of Hash where { .<Subtype> && (! .<FT> || $_ ~~ PDF::Field) }
multi sub coerce(Hash $annot is rw where {.<FT>:exists}, AnnotLike) {
    # secondary coercement needed to a field
    my PDF::Field $delegate .= field-delegate($annot);
    $delegate.COERCE: $annot;
}
multi sub coerce($_, AnnotLike) {
    warn "unable to coerce: {.raku} ({.WHAT.^name}) to an annotation";
}
has AnnotLike @.Annots is entry(:&coerce);                  # (Optional) An array of annotation dictionaries representing annotations associated with the page
has PDF::Page::AdditionalActions $.AA is entry(:alias<additional-actions>);  # (Optional; PDF 1.2) An additional-actions dictionary defining actions to be performed when the page is opened or closed
use PDF::Metadata::XML;
has PDF::Metadata::XML $.Metadata is entry;                 # (Optional; PDF 1.4) A metadata stream containing metadata for the page
has Hash $.PieceInfo is entry;                              # (Optional; PDF 1.3) A page-piece dictionary associated with the page
has UInt $.StructParents is entry(:alias<struct-parent>);   # (Required if the page contains structural content items; PDF 1.3) The integer key of the page’s entry in the structural parent tree
has Str $.ID is entry;                       # (Optional; PDF 1.3; indirect reference preferred) The digital identifier of the page’s parent Web Capture content set
has Numeric $.PZ is entry(:alias<preferred-zoom>);          # (Optional; PDF 1.3) The page’s preferred zoom (magnification) factor
my role SeparationInfo does PDF::COS::Tie::Hash {
    use ISO_32000::Table_364-Entries_in_a_separation_dictionary;
    also does ISO_32000::Table_364-Entries_in_a_separation_dictionary;
    use ISO_32000_2::Table_400-Entries_in_a_separation_dictionary;
    also does ISO_32000_2::Table_400-Entries_in_a_separation_dictionary;
    has PDF::Page @.Pages is entry;
    has Str $.DeviceColorant is entry;
    has Array $.ColorSpace is entry;
}
has SeparationInfo $.SeparationInfo is entry;               # (Optional; PDF 1.3) A separation dictionary containing information needed to generate color separations for the page
has PDF::COS::Name $.Tabs is entry;                         # (Optional; PDF 1.5) A name specifying the tab order to be used for annotations on the page
has PDF::COS::Name $.TemplateInstantiated is entry;         # (Required if this page was created from a named page object; PDF 1.5) The name of the originating page object
has Hash $.PresSteps is entry;                              # (Optional; PDF 1.5) A navigation node dictionary representing the first node on the page
has Numeric $.UserUnit is entry(:default(1.0));             # (Optional; PDF 1.6) A positive number giving the size of default user space units, in multiples of 1 ⁄ 72 inch
has Hash @.VP is entry(:alias<view-ports>);  # Optional; PDF 1.6) An array of viewport dictionaries
has PDF::Filespec @.AF is entry;                            # Optional; PDF 2.0) An array of one or more file specification dictionaries which denote the associated files for this page.
has PDF::OutputIntent @.OutputIntents is entry;             # Optional; PDF 2.0) An array of output intent dictionaries that specify the colour characteristics of output devices on which this page might be rendered
has Hash $.DPart is entry(:indirect);                       # (Required, if this page is within the range of a DPart, not permitted otherwise; PDF 2.0) An indirect reference to the DPart dictionary whose range of pages includes this page object

method fields {
    with self.Annots -> $annots {
        $annots.keys.map({$annots[$_]}).grep(PDF::Field);
    }
    else { [] }
}

method cb-check {
    die "/LastModified is required in Page objects when /PieceInfo is present"
        if (self<PieceInfo>:exists) && !(self<LastModified>:exists);
}


