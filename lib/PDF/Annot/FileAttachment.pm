use v6;
use PDF::Annot::Markup;

class PDF::Annot::FileAttachment
    is PDF::Annot::Markup {

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::ByteString;
    use PDF::Filespec;

    my subset Filespec where PDF::COS::ByteString | PDF::Filespec; #| [PDF 32000-1:2008] 7.11.2 File Specification Strings
    multi sub coerce(Hash $_, Filespec) {
        PDF::COS.coerce($_,  PDF::Filespec);
    }
    has Filespec $.FS is entry(:required, :alias<file-spec>, :&coerce); #| (Required) The file associated with this annotation.
    has PDF::COS::Name $.Name is entry(:alias<icon-name>);    #| (Optional) The name of an icon that is used in displaying the annotation. Conforming readers shall provide predefined icon appearances for at least the following standard names: GraphPushPin, PaperclipTag
}


