use v6;

use PDF::COS::Dict;
use PDF::Class::Type;

# /Type /Group - group attributes dictionary
class PDF::Group
    is PDF::COS::Dict
    does PDF::Class::Type['Type','S'] {

    # see [Table 96 – Entries Common to all Group Attributes Dictionaries]
    use ISO_32000::Group_Attributes;
    also does ISO_32000::Group_Attributes;
    use PDF::COS::Tie;
    use PDF::COS::Name;

    has PDF::COS::Name $.Type is entry where 'Group';
    has PDF::COS::Name $.S is entry;
}
