use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;

# /Type /Outlines - the Outlines dictionary

class PDF::Doc::Type::Outlines
    is PDF::DAO::Dict
    does PDF::Doc::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    my subset Name-Outlines of PDF::DAO::Name where 'Outlines';
    has PDF::DAO::Name $.Type is entry;
    use PDF::Doc::Type::OutlineItem;

    # see TABLE 8.3 Entries in the outline dictionary
    has PDF::Doc::Type::OutlineItem $.First is entry(:indirect); #| (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the first top-level item in the outline.
    has PDF::Doc::Type::OutlineItem $.Last is entry(:indirect);  #| (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the last top-level item in the outline.
    has UInt $.Count is entry;             #| (Required if the document has any open outline entries) The total number of open items at all levels of the outline. This entry should be omitted if there are no open outline items.

}

