use v6;
use PDF::Annot::Markup;

class PDF::Annot::FileAttachment
    is PDF::Annot::Markup {

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::ByteString;
    use PDF::Filespec :File, :&to-file;

    use ISO_32000::Table_184-Additional_entries_specific_to_a_file_attachment_annotation;
    also does ISO_32000::Table_184-Additional_entries_specific_to_a_file_attachment_annotation;

    has File $.FS is entry(:required, :alias<file-spec>, :coerce(&to-file)); # (Required) The file associated with this annotation.
    has PDF::COS::Name $.Name is entry(:alias<icon-name>);    # (Optional) The name of an icon that is used in displaying the annotation. Conforming readers shall provide predefined icon appearances for at least the following standard names: GraphPushPin, PaperclipTag
}


