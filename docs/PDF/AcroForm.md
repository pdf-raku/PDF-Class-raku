[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



AcroForm role - see PDF::Catalog - /AcroForm entry

### has Positional[PDF::Field] @.Fields

(Required) An array of references to the document’s root fields (those with no ancestors in the field hierarchy).

### method fields

```raku
method fields() returns Array
```

returns an inorder array of all descendant fields

### method fields-hash

```raku
method fields-hash(
    Array $fields-arr = Code.new,
    :$key! where { ... }
) returns Hash
```

return fields mapped to a hash. Default key is /T entry

### has Bool $.NeedAppearances

(Optional) A flag specifying whether to construct appearance streams and appearance dictionaries for all widget annotations in the document

### has PDF::AcroForm::SigFlagsInt $.SigFlags

(Optional; PDF 1.3) A set of flags specifying various document-level characteristics related to signature fields

### has Positional[PDF::Field] @.CO

(Required if any fields in the document have additional-actions dictionaries containing a C entry; PDF 1.3) An array of indirect references to field dictionaries with calculation actions, defining the calculation order in which their values will be recalculated when the value of any field changes

### has PDF::Resources $.DR

(Optional) A resource dictionary containing default resources (such as fonts, patterns, or color spaces) to be used by form field appearance streams. At a minimum, this dictionary must contain a Font entry specifying the resource name and font dictionary of the default font for displaying text.

### has Str $.DA

(Optional) A document-wide default value for the DA attribute of variable text fields

### has UInt $.Q

(Optional) A document-wide default value for the Q attribute of variable text fields

### has PDF::AcroForm::XFA $.XFA

(Optional; PDF 1.5) A stream or array containing an XFA resource, whose format is described by the Data Package (XDP) Specification.

