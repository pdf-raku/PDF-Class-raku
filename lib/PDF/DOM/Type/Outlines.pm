use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Outlines - the Outlines dictionary

class PDF::DOM::Type::Outlines
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    # see TABLE 8.3 Entries in the outline dictionary
    has Hash $.First is entry(:indirect); #| (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the first top-level item in the outline.
    has Hash $.Last is entry(:indirect);  #| (Required if there are any open or closed outline entries; must be an indirect reference) An outline item dictionary representing the last top-level item in the outline.
    has Int $.Count is entry;             #| (Required if the document has any open outline entries) The total number of open items at all levels of the outline. This entry should be omitted if there are no open outline items.

}
