[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Positional[PDF::StructElem] @.K

The immediate child or children of the structure tree root in the structure hierarchy. The value may be either a dictionary representing a single structure element or an array of such dictionaries.

### has PDF::NameTree[PDF::StructElem::StructElemChild] $.IDTree

(Required if any structure elements have element identifiers) A name tree that maps element identifiers to the structure elements they denote.

### has PDF::NumberTree[PDF::StructElem::StructElemChild] $.ParentTree

(Required if any structure element contains content items) A number tree used in finding the structure elements to which content items belong. Each integer key in the number tree shall correspond to a single page of the document or to an individual object (such as an annotation or an XObject) that is a content item in its own right. The integer key shall be the value of the StructParent or StructParents entry in that object. The form of the associated value shall depend on the nature of the object:

### has UInt $.ParentTreeNextKey

(Optional) An integer greater than any key in the parent tree, shall be used as a key for the next entry added to the tree.

### has Associative[PDF::StructTreeRoot::StandardStructureType] %.RoleMap

A dictionary that shall map the names of structure types used in the document to their approximate equivalents in the set of standard structure types.

### has Associative[PDF::StructTreeRoot::ClassMap] %.ClassMap

A dictionary that maps name objects designating attribute classes to the corresponding attribute objects

### has Positional[PDF::Namespace] @.Namespaces

(Required if any structure elements have namespace identifiers; PDF 2.0) An array of namespaces used within the document

### has Positional[PDF::Filespec] @.PronunciationLexicon

(Optional; PDF 2.0) An array containing one or more indirect specifications references to file specification dictionaries, where each specified file is a pronunciation lexicon, which is an XML file conforming to the Pronunciation Lexicon Specification (PLS) Version 1.0.

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries (7.11.3, "File specification dictionaries") which denote the associated files for the entire structure tree.

