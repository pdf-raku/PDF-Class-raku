use v6;

use PDF::COS::Tie::Hash;

role PDF::CIDSystemInfo
    does PDF::COS::Tie::Hash {

    # use ISO_32000::Table_116-Entries_in_a_CIDSystemInfo_dictionary;
    # also does ISO_32000::Table_116-Entries_in_a_CIDSystemInfo_dictionary;

    use PDF::COS::Tie;

    has Str $.Registry is entry(:required);    # A string identifying the issuer of the character collection—for example, Adobe.
    has Str $.Ordering is entry(:required);    # (Required) A string that uniquely names the character collection within the specified registry—for example, Japan1
    has UInt $.Supplement is entry(:required); # (Required) The supplement number of the character collection

}
