use v6;

use PDF::COS::Tie::Hash;

role PDF::Names does PDF::COS::Tie::Hash {
    # use ISO_32000::Table_31-Entries_in_the_name_dictionary;
    # also does ISO_32000::Table_31-Entries_in_the_name_dictionary;

    use PDF::COS::Tie;
    use PDF::NameTree;
    use PDF::Destination :DestNamed, :coerce-dest;

    has PDF::NameTree[DestNamed, :coerce(&coerce-dest)] $.Dests is entry;  # (Optional; PDF 1.2) A name tree mapping name strings to destinations.
    has PDF::NameTree $.AP is entry;                     # (Optional; PDF 1.3) A name tree mapping name strings to annotation appearance streams.
    has PDF::NameTree $.JavaScript is entry;             # (Optional; PDF 1.3) A name tree mapping name strings to document-level JavaScript actions.
    has PDF::NameTree $.Pages is entry;                  # (Optional; PDF 1.3) A name tree mapping name strings to visible pages for use in interactive forms.
    has PDF::NameTree $.Templates is entry;              # (Optional; PDF 1.3) A name tree mapping name strings to invisible (template) pages for use in interactive forms.
    has PDF::NameTree $.IDS is entry;                    # (Optional; PDF 1.3) A name tree mapping digital identifiers to Web Capture content sets.
    has PDF::NameTree $.URLS is entry;                   # (Optional; PDF 1.3) A name tree mapping uniform resource locators (URLs) to Web Capture content sets10.4, "Content Sets").
    use PDF::Filespec :File, :to-file;
    has PDF::NameTree[File, :coerce(&to-file)] $.EmbeddedFiles is entry;          # (Optional; PDF 1.4) A name tree mapping name strings to file specifications for embedded file streams.
    has PDF::NameTree $.AlternatePresentations is entry; # (Optional; PDF 1.4) A name tree mapping name strings to alternate presentations.
    has PDF::NameTree $.Renditions is entry;             # (Optional; PDF 1.5) A name tree mapping name strings (which shall have Unicode encoding) to rendition objects.
}
