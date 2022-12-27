
# /Type /Group - group attributes dictionary
unit class PDF::Group;

use PDF::COS::Dict;
use PDF::Class::Type;

also is PDF::COS::Dict;
also does PDF::Class::Type::Subtyped;

# use ISO_32000::Table_96-Entries_Common_to_all_Group_Attributes_Dictionaries;
# also does ISO_32000::Table_96-Entries_Common_to_all_Group_Attributes_Dictionaries;

use PDF::COS::Tie;
use PDF::COS::Name;

has PDF::COS::Name $.Type is entry(:alias<type>) where 'Group';
has PDF::COS::Name $.S is entry(:alias<subtype>);
