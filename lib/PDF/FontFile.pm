use PDF::FontStream;
use PDF::COS::Stream;
# See [PDF 320000 - Table 127 – Additional entries in an embedded font stream dictionary]
class PDF::FontFile
    does PDF::FontStream
    is PDF::COS::Stream {
    use PDF::COS::Name;
    use PDF::COS::Tie;
    my subset Subtype of PDF::COS::Name where 'Type1C'|'CIDFontType0C'|'OpenType';
    has Subtype $.Subtype is entry(:required);
}
