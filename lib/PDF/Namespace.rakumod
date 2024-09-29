unit role PDF::Namespace;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use ISO_32000_2::Table_356-Entries_in_a_namespace_dictionary;
also does ISO_32000_2::Table_356-Entries_in_a_namespace_dictionary;

use PDF::COS::Tie;
use PDF::COS::Dict;
use PDF::COS::Name;
use PDF::COS::TextString;

use PDF::Filespec :FileRef;

has PDF::COS::Name $.Type is entry where 'Namespace'; # Optional; PDF 2.0) The type of PDF object that this dictionary describes. If present, shall be Namespace.

has PDF::COS::TextString $.NS is entry(:required); # (Required; PDF 2.0) The string defining the namespace name which this entry identifies (conventionally a uniform resource identifier, or URI).

has FileRef $.Schema is entry; # Optional; PDF 2.0) A file specification identifying the schema file, which defines this namespace.

has PDF::COS::Dict $.RoleMapNS is entry; # (Optional; PDF 2.0) A dictionary that shall, if present, map the names of
# structure types used in the namespace to their approximate equivalents in
# another namespace. The dictionary shall be comprised of a set of keys
# representing structure element types in the namespace defined within this
# namespace dictionary. The corresponding value for each of these keys shall
# either be a single name identifying a structure element type in the default
# standard structure namespace or an array where the first value shall be a
# structure element type name in a target namespace with the second value being
# an indirect reference to the target namespace dictionary.
