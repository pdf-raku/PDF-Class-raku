[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has <anon> $.Type

Optional; PDF 2.0) The type of PDF object that this dictionary describes. If present, shall be Namespace.

### has PDF::COS::TextString $.NS

(Required; PDF 2.0) The string defining the namespace name which this entry identifies (conventionally a uniform resource identifier, or URI).

### has PDF::Filespec::FileRef $.Schema

Optional; PDF 2.0) A file specification identifying the schema file, which defines this namespace.

### has PDF::COS::Dict $.RoleMapNS

(Optional; PDF 2.0) A dictionary that shall, if present, map the names of structure types used in the namespace to their approximate equivalents in another namespace.

