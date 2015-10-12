use v6;

use PDF::DAO::Dict;
use PDF::DOM::Type;

# /Type /OBJR - a node in the page tree
class PDF::DOM::Type::OBJR
    is PDF::DAO::Dict
    does PDF::DOM::Type {

    # see [PDF 1.7 TABLE 10.12 Entries in an object reference dictionary]
    use PDF::DAO::Tie;
    has Hash $.Pg is entry(:indirect);       #| (Optional; must be an indirect reference) The page object representing the page on which the object is rendered. This entry overrides any Pg entry in the structure element containing the object reference; it is required if the structure element has no such entry.
    has $.Obj is entry(:required,:indirect); #| (Required; must be an indirect reference) The referenced object.

}
