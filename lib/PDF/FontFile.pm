use PDF::COS::Stream;
# See [PDF 320000 - Table 127 – Additional entries in an embedded font stream dictionary]
class PDF::FontFile
    is PDF::COS::Stream {
    use PDF::COS::Name;
    use PDF::COS::Tie;
    my subset Subtype of PDF::COS::Name where 'Type1C'|'CIDFontType0C'|'OpenType';
    has Subtype $.Subtype is entry(:required);
    has Int $.Length1 is entry; #| (Required for Type 1 and TrueType fonts) The length in bytes of the clear-text portion of the Type 1 font program, or the entire TrueType font program, after it has been decoded using the filters specified by the stream’s Filter entry, if any.
    has Int $.Length2 is entry; #| (Required for Type 1 fonts) The length in bytes of the encrypted portion of the Type 1 font program after it has been decoded using the filters specified by the stream’s Filter entry.
    has Int $.Length3 is entry; #| (Required for Type 1 fonts) The length in bytes of the fixed-content portion of the Type 1 font program after it has been decoded using the filters specified by the stream’s Filter entry. If Length3 is 0, it indicates that the 512 zeros and cleartomark have not been included in the FontFile font program and shall be added by the conforming reader.
    use PDF::Metadata::XML;
    has PDF::Metadata::XML $.Metadata is entry; #| (Optional; PDF 1.4) A metadata stream containing metadata for the embedded font program.
}
