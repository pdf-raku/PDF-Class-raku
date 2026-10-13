[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Field::FieldSubtypeName $.FT

Required for terminal fields; inheritable) The type of field that this dictionary describes

### has PDF::Field $.Parent

(Required if this field is the child of another in the field hierarchy; absent otherwise) The field that is the immediate parent of this one (the field, if any, whose Kids array includes this field). A field can have at most one parent; that is, it can be included in the Kids array of at most one other field.

### has Positional[PDF::Field::AnnotOrField] @.Kids

(Sometimes required, as described below) An array of indirect references to the immediate children of this field. In a non-terminal field, the Kids array is required to refer to field dictionaries that are immediate descendants of this field. In a terminal field, the Kids array ordinarily must refer to one or more separate widget annotations that are associated with this field. However, if there is only one associated widget annotation, and its contents have been merged into the field dictionary, Kids must be omitted.

### method fields

```raku
method fields() returns Mu
```

return any terminal descendants, or self

### method take-fields

```raku
method take-fields() returns Mu
```

take terminal fields

### method annots

```raku
method annots() returns Mu
```

return immediate annotations only. return ourself, if we're an annotation, otherwise return any annots from our immediate kids

### has PDF::COS::TextString $.T

Optional) The partial field name

### has PDF::COS::TextString $.TU

(Optional; PDF 1.3) An alternate field name to be used in place of the actual field name wherever the field must be identified in the user interface (such as in error or status messages referring to the field). This text is also useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes

### has PDF::COS::TextString $.TM

(Optional; PDF 1.3) The mapping name to be used when exporting interactive form field data from the document.

### has UInt $.Ff

Optional; inheritable) A set of flags specifying various characteristics of the field

### has PDF::Field::AdditionalActions $.AA

(Optional; PDF 1.2) An additional-actions dictionary defining the field’s behavior in response to various trigger events. This entry has exactly the same meaning as the AA entry in an annotation dictionary

### has Str $.DA

(Required; inheritable) The default appearance string containing a sequence of valid page-content graphics or text state operators that define such properties as the field’s text size and color.

### has PDF::Field::QuaddingFlags $.Q

(Optional; inheritable) A code specifying the form of quadding (justification) to be used in displaying the text: 0: Left-justified 1: Centered 2: Right-justified

### has PDF::COS::TextString $.DS

Optional; PDF 1.5) A default style string

### has PDF::Class::Defs::TextOrStream $.RV

(Optional; PDF 1.5) A rich text string

