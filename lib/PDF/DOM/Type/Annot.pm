use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

#| /Type /Annot Annotations
#| See [PDF 1.7 Section 8.4.1 - Annotation Dictionaries ]
class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    # See [PDF Spec 1.7 table 8.15 - Entries common to all annotation dictionaries ]
    has Array $.Rect is entry(:required); #| (Required) The annotation rectangle, defining the location of the annotation on the page in default user space units.
    has Str $.Contents is entry;          #| (Optional) Text to be displayed for the annotation or, if this type of annotation does not display text, an alternate description of the annotation’s contents in human-readable form
    has Hash $.P is entry;                #| (Optional; PDF 1.3; not used in FDF files) An indirect reference to the page object with which this annotation is associated.
    has Str $.NM is entry;                #| (Optional; PDF 1.4) The annotation name, a text string uniquely identifying it among all the annotations on its page.
    has Str $.M is entry;                 #| (Optional; PDF 1.1) The date and time when the annotation was most recently modified.
    subset AnnotFlagsInt of Int where 0 ..^ 2 +< 9;
    has AnnotFlagsInt $.F is entry;       #| (Optional; PDF 1.1) A set of flags specifying various characteristics of the annotation
    has Hash $.AP is entry;               #| (Optional; PDF 1.2) An appearance dictionary specifying how the annotation is presented visually on the page
    has PDF::Object::Name $.AS is entry;  #| (Required if the appearance dictionary AP contains one or more subdictionaries; PDF 1.2) The annotation’s appearance state, which selects the applicable appearance stream from an appearance subdictionary
    has Array $.Border is entry;          #| (Optional) An array specifying the characteristics of the annotation’s border. The border is specified as a rounded rectangle.
    has Array $.C is entry;               #| (Optional; PDF 1.1) An array of numbers in the range 0.0 to 1.0, representing a color used for (*) background, when closed, (*) title bar of pop-up window, (*) link border
    has Int $.StructParent is entry;      #| (Required if the annotation is a structural content item; PDF 1.3) The integer key of the annotation’s entry in the structural parent tree
    has Hash $.OC is entry;               #| (Optional; PDF 1.5) An optional content group or optional content membership dictionary (see Section 4.10, “Optional Content”) specifying the optional content properties for the annotation.

}
