[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Annot::Text
----------------------

/Type Annot - Annotation subtypes See [PDF 32000 Section 12.5 Annotations]

### has Bool $.Open

(Optional) A flag specifying whether the annotation should initially be displayed open. Default value: false (closed).

### has PDF::COS::Name $.Name

(Optional) The name of an icon to be used in displaying the annotation. Viewer applications should provide predefined icon appearances for at least the following standard names:

### has <anon> $.State

(Optional; PDF 1.5) The state to which the original annotation should be set; see “Annotation States,” above. Default: “Unmarked” if StateModel is “Marked”; “None” if StateModel is “Review

### has <anon> $.StateModel

(Required if State is present, otherwise optional; PDF 1.5) The state model corresponding to State; see “Annotation States,” above

