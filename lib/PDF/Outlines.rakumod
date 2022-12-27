use v6;


#| /Type /Outlines - the Outlines dictionary
unit role PDF::Outlines;

use PDF::Class::OutlineNode;
use PDF::COS::Tie::Hash;
also does PDF::Class::OutlineNode;
also does PDF::COS::Tie::Hash;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Outline;

# use ISO_32000::Table_152-Entries_in_the_outline_dictionary;
# also does ISO_32000::Table_152-Entries_in_the_outline_dictionary;

has PDF::COS::Name $.Type is entry where 'Outlines';  # (Optional) The type of PDF object that this dictionary describes; if present, shall be Outlines for an outline dictionary.

# see TABLE 8.3 Entries in the outline dictionary
has PDF::Outline $.First is entry(:indirect); # (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the first top-level item in the outline.
has PDF::Outline $.Last is entry(:indirect);  # (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the last top-level item in the outline.
has Int $.Count is entry;                    # (Required if the document has any open outline entries) The total number of open items at all levels of the outline. This entry should be omitted if there are no open outline items.


