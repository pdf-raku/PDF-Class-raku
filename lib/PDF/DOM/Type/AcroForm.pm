use v6;

use PDF::DOM::Type; # just to help rakudo
use PDF::Object::Tie;
use PDF::Object::Tie::Hash;

# AcroForm role - see PDF::DOM::Type::Catalog - /AcroForm entry

role PDF::DOM::Type::AcroForm
    does PDF::Object::Tie::Hash {

    # see [PDF 1.7 TABLE 8.67 Entries in the interactive form dictionary]
    use PDF::DOM::Type::Field;
    use PDF::Object;
    multi sub coerce(PDF::Object::Dict $dict is rw, PDF::DOM::Type::Field) {
	PDF::DOM::Type::Field.coerce($dict)
    }
    has PDF::DOM::Type::Field @.Fields is entry(:required, :&coerce);    #| (Required) An array of references to the document’s root fields (those with no ancestors in the field hierarchy).

    has Bool $.NeedAppearances is entry;       #| (Optional) A flag specifying whether to construct appearance streams and appearance dictionaries for all widget annotations in the document

    my subset SigFlagsInt of UInt where 0..3;
    has SigFlagsInt $.SigFlags is entry;       #| (Optional; PDF 1.3) A set of flags specifying various document-level characteristics related to signature fields

    has Array $.CO is entry;                   #| (Required if any fields in the document have additional-actions dictionaries containing a C entry; PDF 1.3) An array of indirect references to field dictionaries with calculation actions, defining the calculation order in which their values will be recalculated when the value of any field changes

    has Hash $.DR is entry;                    #| (Optional) A resource dictionary containing default resources (such as fonts, patterns, or color spaces) to be used by form field appearance streams. At a minimum, this dictionary must contain a Font entry specifying the resource name and font dictionary of the default font for displaying text.

    has Str $.DA is entry;                     #| (Optional) A document-wide default value for the DA attribute of variable text fields

    has Int $.Q is entry;                      #| (Optional) A document-wide default value for the Q attribute of variable text fields


    use PDF::Object::Stream;
    my subset StreamOrArray of Any where PDF::Object::Stream | Array;
    has StreamOrArray $.XFA is entry;          #| (Optional; PDF 1.5) A stream or array containing an XFA resource, whose format is described by the Data Package (XDP) Specification. (see the Bibliography).
                                               #| The value of this entry must be either a stream representing the entire contents of the XML Data Package or an array of text string and stream pairs representing the individual packets comprising the XML Data Package

}
