use v6;

use PDF::COS::Tie::Hash;

#| an entry in the StructTree
#| See PDF::StructTreeRoot

role PDF::StructElem
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;

    has PDF::COS::Name $.S is entry(:required, :alias<structure-type>); #| (Required) The structure type, a name object identifying the nature of the structure element and its role within the document, such as a chapter, paragraph, or footnote
    has Hash $.P is entry(:required, :alias<parent>);         #| (Required; shall be an indirect reference) The structure element that is the immediate parent of this one in the structure hierarchy.
    has Str $.ID is entry;    #| (Optional) The element identifier, a byte string designating this structure element. The string shall be unique among all elements in the document’s structure hierarchy. The IDTree entry in the structure tree root (see Table 322) defines the correspondence between element identifiers and the structure elements they denote.
    use PDF::Page;
    has PDF::Page $.Pg is entry(:indirect, :alias<page>); #|dictionary (Optional; shall be an indirect reference) A page object representing a page on which some or all of the content items designated by the K entry shall be rendered.
    use PDF::MCR;  # Marked Content Reference
    use PDF::OBJR; # Object Reference
    my subset StructElemChild where PDF::MCR|PDF::OBJR|UInt|PDF::StructElem;
    multi sub coerce(Hash $obj, StructElemChild) {
        PDF::COS.coerce($obj, PDF::StructElem);
    }
    has StructElemChild @.K is entry(:array-or-item, :alias<children>, :&coerce);    #| (Optional) The children of this structure element. The value of this entry may be one of the following objects or an array consisting of one or more of the following objects:
    #| • A structure element dictionary denoting another structure element
    #| • An integer marked-content identifier denoting a marked-content sequence
    #| • A marked-content reference dictionary denoting a marked-content sequence
    #| • An object reference dictionary denoting a PDF object
    #| Each of these objects other than the first shall be considered to be a content item;
    #| If the value of K is a dictionary containing no Type entry, it shall be assumed to be a structure element dictionary.
    has Hash @.A is entry(:alias<attributes>, :array-or-item);   #| (Optional) A single attribute object or array of attribute objects associated with this structure element. Each attribute object shall be either a dictionary or a stream. If the value of this entry is an array, each attribute object in the array may be followed by an integer representing its revision number.
    has @.C is entry(:array-or-item);    #| (Optional) An attribute class name or array of class names associated with this structure element. If the value of this entry is an array, each class name in the array may be followed by an integer representing its revision number.
# If both the A and C entries are present and a given attribute is
# specified by both, the one specified by the A entry shall take
# precedence.
    has UInt $.R is entry(:alias<revision>); #| (Optional) The current revision number of this structure element. The value shall be a non-negative integer. Default value: 0.
}
