use v6;

use PDF::COS::Tie::Hash;

#| Appearance role - see PDF::Annot - /AP entry

role PDF::Appearance
    does PDF::COS::Tie::Hash {

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Stream;

    # use ISO_32000::Table_168-Entries_in_an_appearance_dictionary;
    # also does ISO_32000::Table_168-Entries_in_an_appearance_dictionary;

    my subset FormLike of PDF::COS::Stream where .<Subtype> ~~ 'Form'; # autoloaded PDF::XObject::Form
    my role AppearanceStatus
	does PDF::COS::Tie::Hash {
	has FormLike $.Off is entry;
	has FormLike $.On  is entry;
	has FormLike $.Yes is entry;
    }

    my subset AppearanceLike where FormLike | AppearanceStatus;
    multi sub coerce(PDF::COS::Stream $dict is rw, AppearanceLike) {
        fail "Stream not of /Subtype /Form"
    }
    multi sub coerce(Hash $dict is rw, AppearanceLike) {
	PDF::COS.coerce($dict,  AppearanceStatus)
    }

    has AppearanceLike $.N is entry(:&coerce, :alias<normal>, :required); # (Required) The annotation’s normal appearance.
    has AppearanceLike $.R is entry(:&coerce, :alias<rollover>);          # (Optional) The annotation’s rollover appearance. Default value: the value of the N entry.
    has AppearanceLike $.D is entry(:&coerce, :alias<down>);              # (Optional) The annotation’s down appearance. Default value: the value of the N entry.

}
