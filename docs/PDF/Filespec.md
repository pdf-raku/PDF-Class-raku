[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has <anon> $.Type

(Required if an EF or RF entry is present; recommended always) The type of PDF object that this dictionary describes; shall be Filespec for a file specification dictionary.

### has PDF::COS::Name $.FS

(Optional) The name of the file system that shall be used to interpret this file specification. If this entry is present, all other entries in the dictionary shall be interpreted by the designated file system. PDF shall define only one standard file system name, URL; an application can register other names. This entry shall be independent of the F, UF, DOS, Mac, and Unix entries.

### has PDF::COS::ByteString $.F

(Required if the DOS, Mac, and Unix entries are all absent; amended with the UF entry for PDF 1.7) A file specification string of the form described in 7.11.2, "File Specification Strings," or (if the file system is URL) a uniform resource locator, as described in 7.11.5, "URL Specifications."

### has PDF::COS::TextString $.UF

(Optional, but recommended if the F entry exists in the dictionary; PDF 1.7) A Unicode text string that provides file specification of the form described in 7.11.2, "File Specification Strings." This is a text string encoded using PDFDocEncoding or UTF-16BE with a leading byte-order marker (as defined in 7.9.2.2, "Text String Type"). The F entry should be included along with this entry for backwards compatibility reasons.

### has PDF::COS::ByteString $.DOS

(Optional) A file specification string representing a DOS file name. This entry is obsolescent and should not be used by conforming writers.

### has PDF::COS::ByteString $.Mac

(Optional) A file specification string representing a Mac OS file name. This entry is obsolescent and should not be used by conforming writers.

### has PDF::COS::ByteString $.Unix

(Optional) A file specification string representing a UNIX file name. This entry is obsolescent and should not be used by conforming writers.

### has Positional[PDF::COS::ByteString] @.ID

(Optional) An array of two byte strings constituting a file identifier that should be included in the referenced file.

### has Bool $.V

(Optional; PDF 1.2) A flag indicating whether the file referenced by the file specification is volatile (changes frequently with time). If the value is true, applications shall not cache a copy of the file. For example, a movie annotation referencing a URL to a live video camera could set this flag to true to notify the conforming reader that it should re-acquire the movie each time it is played. Default value: false.

### has Associative[PDF::EmbeddedFile] %.EF

(Required if RF is present; PDF 1.3; amended to include the UF key in PDF 1.7) A dictionary containing a subset of the keys F, UF, DOS, Mac, and Unix, corresponding to the entries by those names in the file specification dictionary. The value of each such key shall be an embedded file stream containing the corresponding file. If this entry is present, the Type entry is required and the file specification dictionary shall be indirectly referenced. The F and UF entries should be used in place of the DOS, Mac, or Unix entries.

### has Associative[Array] %.RF

(Optional; PDF 1.3) A dictionary with the same structure as the EF dictionary, which shall be present. Each key in the RF dictionary shall also be present in the EF dictionary. Each value shall be a related files array identifying files that are related to the corresponding file in the EF dictionary. If this entry is present, the Type entry is required and the file specification dictionary shall be indirectly referenced.

### has PDF::COS::TextString $.Desc

(Optional; PDF 1.6) Descriptive text associated with the file specification. It shall be used for files in the EmbeddedFiles name tree.

### has PDF::COS::Dict $.CI

(Optional; shall be indirect reference; PDF 1.7) A collection item dictionary, which shall be used to create the user interface for portable collections.

### has PDF::Class::Image $.Thumb

(Optional; PDF 2.0) A stream object defining the thumbnail image for the file specification.

### has PDF::COS::Dict $.EP

(PDF 2.0; Required if this file specification references an encrypted payload document as described in 7.6.7, "Unencrypted wrapper document") The value of this key is an encrypted payload dictionary which identifies that the file specified in the EF dictionary is an encrypted payload.

### has PDF::Filespec::AFRelationship $.AFRelationship

(Optional; PDF 2.0) A name value that represents the relationship between the component of this PDF document that refers to this file specification and the associated file denoted by this file specification dictionary.

