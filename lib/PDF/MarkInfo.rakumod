unit role PDF::MarkInfo;
use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use PDF::COS::Tie;

# use ISO_32000::Table_321-Entries_in_the_mark_information_dictionary;
# also does ISO_32000::Table_321-Entries_in_the_mark_information_dictionary;
has Bool $.Marked is entry;          # (Optional) A flag indicating whether the document conforms to Tagged PDF conventions. Default value: false.
                                    # Note: If Suspects is true, the document may not completely conform to Tagged PDF conventions.
has Bool $.UserProperties is entry;  # (Optional; PDF 1.6) A flag indicating the presence of structure elements that contain user properties attributes. Default value: false.
has Bool $.Suspects is entry;        # Optional; PDF 1.6) A flag indicating the presence of tag suspects. Default value: false.
