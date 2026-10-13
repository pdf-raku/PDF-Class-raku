[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::OCG
--------------

/Type /OCG - Optional Content Group

### has PDF::COS::TextString $.Name

(Required) The name of the optional content group, suitable for presentation in a reader’s user interface.

### has Positional[PDF::COS::Name] @.Intent

(Optional) A single intent name or an array containing any combination of names. PDF defines two names, View and Design, that may indicate the intended use of the graphics in the group. A conforming reader may choose to use only groups that have a specific intent and ignore others. Default value: View.



Optional Content Usage dictionary



Optional Content Creator Info dictionary

### has PDF::COS::TextString $.Creator

A text string specifying the application that created the group.

### has PDF::COS::Name $.Subtype

A name defining the type of content controlled by the group.

### has PDF::OCG::OCUsage::CreatorInfo $.CreatorInfo

Optional) A dictionary used by the creating application to store application-specific data associated with this optional content group.



Optional Content Language Info dictionary

### has PDF::COS::TextString $.Lang

A text string that specifies a language and possibly. For example, es-MX represents Mexican Spanish

### has PDF::OCG::OCUsage::ON-or-OFF $.Preferred

name whose values shall be either ON or OFF. Default value: OFF.



Optional Content Export control dictionary

### has PDF::OCG::OCUsage::ON-or-OFF $.ExportState

name whose values shall be either ON or OFF. Default value: OFF.

### has PDF::OCG::OCUsage::Export $.Export

This value shall indicate the recommended state for content in this group when the document (or part of it) is saved by a conforming reader to a format that does not support optional content (for example, a raster image format).



Optional Content Zoom control dictionary

### has Numeric $.min

The minimum recommended magnification factor at which the group shall be ON. Default value: 0.

### has Numeric $.max

The magnification factor below which the group shall be ON. Default value: infinity.

### has PDF::OCG::OCUsage::Zoom $.Zoom

Optional) A dictionary specifying a range of magnifications at which the content in this optional content group is best viewed.



Optional Content Print control dictionary

### has PDF::COS::Name $.Subtype

A name object specifying the kind of content controlled by the group; for example, Trapping, PrintersMarks and Watermark.

### has PDF::OCG::OCUsage::ON-or-OFF $.PrintState

A name that shall be either ON or OFF, indicating that the group shall be set to that state when the document is printed from a conforming reader.

### has PDF::OCG::OCUsage::Print $.Print

Optional) A dictionary specifying that the content in this group is shall be used when printing.



Optional Content View control dictionary

### has PDF::OCG::OCUsage::View $.View

(Optional) A dictionary that shall have a single entry, ViewState, a name that has a value of either ON or OFF,



Optional Content User info dictionary

### has PDF::COS::Name $.Type

A name object that shall be either Ind (individual), Ttl (title), or Org (organization).

### has Positional[PDF::COS::TextString] @.Name

A text string or array of text strings representing the name(s) of the individual, position or organization.

### has PDF::OCG::OCUsage::User $.User

Optional) A dictionary specifying one or more users for whom this optional content group is primarily intended

### has PDF::OCG::OCUsage::PageElement $.PageElement

A dictionary declaring that the group contains a pagination artifact. It shall contain one entry, Subtype, whose value shall be a name that is either HF (header/footer), FG (foreground image or graphic), BG (background image or graphic), or L (logo).

