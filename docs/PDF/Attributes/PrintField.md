[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



PrintField attributes

### has PDF::Attributes::PrintField::Role $.Role

(Optional; not inheritable) The type of form field represented by this graphic. The value of Role is one of the following, and a conforming reader interprets its meaning as defined herein.

### has PDF::Attributes::PrintField::Checked $.checked

(Optional; not inheritable) The state of a radio button or check box field. The value is one of: on, off (default), or neutral. NOTE 2 The case (capitalization) used for this key does not conform to the same conventions used elsewhere in this standard. PDF 2.0

### has PDF::COS::TextString $.Desc

(Optional; not inheritable) The alternate name of the field.

