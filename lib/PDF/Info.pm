use v6;
use PDF::COS::Type::Info;

role PDF::Info does PDF::COS::Type::Info {
    use ISO_32000::Table_317-Entries_in_the_document_information_dictionary;
    also does ISO_32000::Table_317-Entries_in_the_document_information_dictionary;
}
