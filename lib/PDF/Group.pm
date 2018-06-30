use v6;

use PDF::COS::Dict;
use PDF::Class::Type;

# /Type /Group - group attributes dictionary
class PDF::Group
    is PDF::COS::Dict
    does PDF::Class::Type['Type','S'] {

    # see [Table 96 – Entries Common to all Group Attributes Dictionaries]
    use PDF::COS::Tie;
    use PDF::COS::Name;

    has PDF::COS::Name $.Type is entry where 'Group';
}
