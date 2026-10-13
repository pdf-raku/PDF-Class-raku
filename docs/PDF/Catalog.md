[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Catalog
------------------

/Type /Catalog - usually the document root in a PDF

### has PDF::Catalog::PDFVersion $.Version

(Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)



autoloaded PDF::Pages

### has PDF::Catalog::PagesLike $.Pages

(Required; must be an indirect reference) The page tree node that is the root of the document’s page tree



Page Label dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be PageLabel for a page label dictionary.

### has PDF::Catalog::PageLabelNode::NumberingStyle $.S

(Optional) The numbering style that shall be used for the numeric portion of each page label: D: Decimal arabic numerals R: Uppercase roman numerals r: Lowercase roman numerals A: Uppercase letters (A to Z for the first 26 pages, AA to ZZ for the next 26, and so on) a: Lowercase letters (a to z for the first 26 pages, aa to zz for the next 26, and so on) There is no default numbering style; if no S entry is present, page labels consist solely of a label prefix with no numeric portion.

### has PDF::COS::TextString $.P

(Optional) The label prefix for page labels in this range.

### has UInt $.St

(Optional) The value of the numeric portion for the first page label in the range.



Page Labels

### method AT-POS

```raku
method AT-POS(
    Int(Any) $page-idx
) returns Mu
```

page indices, starting at zero

### method page-label

```raku
method page-label(
    Int $page-num where { ... }
) returns Mu
```

page labels, starting at page 1

### has PDF::Catalog::PageLabels $.PageLabels

(Optional; PDF 1.3) A number tree defining the page labeling for the document.

### has PDF::Names $.Names

(Optional; PDF 1.2) The document’s name dictionary

### has Associative[PDF::Destination::DestNamed] %.Dests

(Optional; PDF 1.1; must be an indirect reference) A dictionary of names and corresponding destinations

### has PDF::ViewerPreferences $.ViewerPreferences

(Optional; PDF 1.2) A viewer preferences dictionary specifying the way the document is to be displayed on the screen.

### has PDF::Catalog::PageLayout $.PageLayout

(Optional) A name object specifying the page layout to be used when the document is opened

### has PDF::Catalog::PageMode $.PageMode

(Optional) A name object specifying how the document should be displayed when opened

### has PDF::Outlines $.Outlines

(Optional; must be an indirect reference) The outline dictionary that is the root of the document’s outline hierarchy

### has Positional[PDF::Thread] @.Threads

(Optional; PDF 1.1; must be an indirect reference) An array of thread dictionaries representing the document’s article threads

### has PDF::Catalog::OpenAction $.OpenAction

(Optional; PDF 1.1) A value specifying a destination to be displayed or an action to be performed when the document is opened.

### has PDF::Catalog::AdditionalActions $.AA

(Optional; PDF 1.4) An additional-actions dictionary defining the actions to be taken in response to various trigger events affecting the document as a whole



URI Dictionary

### has PDF::COS::ByteString $.Base

(Optional) The base URI that shall be used in resolving relative URI references. URI actions within the document may specify URIs in partial form, to be interpreted relative to this base address. If no base URI is specified, such partial URIs shall be interpreted relative to the location of the document itself. The use of this entry is parallel to that of the body element <BASE >, as described in the HTML 4.01 Specification

### has PDF::Catalog::URI $.URI

(Optional; PDF 1.1) A URI dictionary containing document-level information for URI

### has PDF::AcroForm $.AcroForm

(Optional; PDF 1.2) The document’s interactive form (AcroForm) dictionary

### has PDF::Metadata::XML $.Metadata

(Optional; PDF 1.4; must be an indirect reference) A metadata stream containing metadata for the document



autoloaded PDF::StructTreeRoot

### has PDF::Catalog::StructTreeLike $.StructTreeRoot

(Optional; PDF 1.3) The document’s structure tree root dictionary

### has PDF::MarkInfo $.MarkInfo

(Optional; PDF 1.4) A mark information dictionary containing information about the document’s usage of Tagged PDF conventions

### has PDF::COS::TextString $.Lang

(Optional; PDF 1.4) A language identifier specifying the natural language for all text in the document except where overridden by language specifications for structure elements or marked content

### has PDF::COS::Dict $.SpiderInfo

(Optional; PDF 1.3) A Web Capture information dictionary containing state information used by the Acrobat Web Capture (AcroSpider) plug-in extension

### has Positional[PDF::OutputIntent] @.OutputIntents

(Optional; PDF 1.4) An array of output intent dictionaries describing the color characteristics of output devices on which the document might be rendered

### has PDF::COS::Dict $.PieceInfo

(Optional; PDF 1.4) A page-piece dictionary associated with the document



autoloaded PDF::OCG (Optional Content Group)

### has PDF::COS::TextString $.Name

(Optional) A name for the configuration, suitable for presentation in a user interface.

### has PDF::COS::TextString $.Creator

(Optional) Name of the application or feature that created thisconfiguration dictionary.

### has PDF::Catalog::OCConfig::BaseState $.BaseState

(Optional) Used to initialize the states of all the optional content groups in a document when this configuration is applied. The value of this entry shall be one of the following names:

### has Positional[PDF::Catalog::OCGLike] @.ON

(Optional) An array of optional content groups whose state shall be set to ON when this configuration is applied. If the BaseState entry is ON, this entry is redundant.

### has Positional[PDF::Catalog::OCGLike] @.OFF

(Optional) An array of optional content groups whose state shall be set to OFF when this configuration is applied. If the BaseState entry is OFF, this entry is redundant.

### has Positional[PDF::COS::Name] @.Intent

name or array (Optional) A single intent name or an array containing any combination of names.

### has Positional @.AS

(Optional) An array of usage application dictionaries.

### has Positional @.Order

array (Optional) An array specifying the order for presentation of optional content groups in a conforming reader’s user interface.

### has PDF::Catalog::OCConfig::ListMode $.ListMode

(Optional) A name specifying which optional content groups in the Order array shall be displayed to the user.

### has Positional @.RBGroups

(Optional) An array consisting of one or more arrays, each of which represents a collection of optional content groups whose states shall be intended to follow a radio button paradigm. That is, the state of at most one optional content group in each array shall be ON at a time. If one group is turned ON, all others shall be turned OFF.

### has Positional[PDF::Catalog::OCGLike] @.Locked

(Optional; PDF 1.6) An array of optional content groups that shall be locked when this configuration is applied.



Optional Content Properties Dictionary

### has Positional[PDF::Catalog::OCGLike] @.OCGs

(Required) An array of indirect references to all the optional content groups in the document, in any order. Every optional content group shall be included in this array

### has PDF::COS::Dict $.D

(Required) The default viewing optional content configuration dictionary.

### has Positional[PDF::Catalog::OCConfig] @.Configs

(Optional) An array of alternate optional content configuration dictionaries.

### has PDF::Catalog::OCProperties $.OCProperties

(Optional; PDF 1.5; required if a document contains optional content) The document’s optional content properties dictionary



Permissions dictionary

### has PDF::Signature $.DocMDP

(Optional) An indirect reference to a signature dictionary (see Table 252). This dictionary shall contain a Reference entry that is a signature reference dictionary (see Table 252) that has a DocMDP transform method and corresponding transform parameters.

### has PDF::Signature $.UR3

(Optional) A signature dictionary that is used to specify and validate additional capabilities (usage rights) granted for this document; that is, the enabling of interactive features of the conforming reader that are not available by default.

### has PDF::Catalog::Permissions $.Perms

(Optional; PDF 1.5) A permissions dictionary that specifies user access permissions for the document.

### has PDF::COS::Dict $.Legal

(Optional; PDF 1.5) A dictionary containing attestations regarding the content of a PDF document, as it relates to the legality of digital signatures

### has Positional[PDF::COS::Dict] @.Requirements

(Optional; PDF 1.7) An array of requirement dictionaries representing requirements for the document.

### has PDF::COS::Dict $.Collection

(Optional; PDF 1.7) A collection dictionary that a PDF consumer uses to enhance the presentation of file attachments stored in the PDF document.

### has Bool $.NeedsRendering

(Optional; PDF 1.7) A flag used to expedite the display of PDF documents containing XFA forms. It specifies whether the document must be regenerated when the document is first opened.

### has PDF::COS::Dict $.DSS

(Optional; PDF 2.0) A DSS dictionary containing document-wide security information.

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries which denote the associated files for this PDF document.

### has PDF::COS::Dict $.DPartRoot

(Optional; PDF 2.0) A DPartRoot dictionary used to describe the document parts hierarchy for this PDF document.

