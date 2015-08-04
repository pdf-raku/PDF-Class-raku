use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::CMap
    is PDF::Object::Stream
    does PDF::DOM::Type {

    # set [PDF 1.7 TABLE 5.17 Additional entries in a CMap dictionary]
    use PDF::Object::Tie;
    use PDF::Object::Name;
    has PDF::Object::Name $.CMapName is entry(:required); #| (Required) The PostScript name of the CMap. It should be the same as the value of CMapName in the CMap file.
    has Hash $.CIDSystemInfo is entry(:required);         #| (Required) A dictionary containing entries that define the character collection for the CIDFont or CIDFonts associated with the CMap
    my subset ZeroOrOne of UInt where 0|1;
    has ZeroOrOne $.WMode is entry;                       #| (Optional) A code that determines the writing mode for any CIDFont with which this CMap is combined. The possible values are 0 for horizontal and 1 for vertical
    my subset NameOrStream of Any where PDF::Object::name | PDF::Object::Stream;
    has NameOrStream $.UseCMap is entry;                  #| (Optional) The name of a predefined CMap, or a stream containing a CMap, that is to be used as the base for this CMap
}