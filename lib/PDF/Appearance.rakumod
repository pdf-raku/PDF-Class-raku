#| Appearance role - see PDF::Annot - /AP entry
unit role PDF::Appearance;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use PDF::COS;
use PDF::COS::Tie;
use PDF::COS::Stream;

use ISO_32000::Table_168-Entries_in_an_appearance_dictionary;
also does ISO_32000::Table_168-Entries_in_an_appearance_dictionary;

use ISO_32000_2::Table_170-Entries_in_an_appearance_dictionary;
also does ISO_32000_2::Table_170-Entries_in_an_appearance_dictionary;

my subset FormLike of PDF::COS::Stream where .<Subtype> ~~ 'Form'; # autoloaded PDF::XObject::Form
my role AppearanceStates
    does PDF::COS::Tie::Hash {
    has FormLike $.Off is entry;
    has FormLike $.On  is entry;
    has FormLike $.Yes is entry;
}

my subset AppearEntry where FormLike | AppearanceStates;
multi sub coerce(PDF::COS::Stream $dict is rw, AppearEntry) {
    warn "Stream not of /Subtype /Form"
}
multi sub coerce(Hash $dict is rw, AppearEntry) {
    AppearanceStates.COERCE: $dict;
}

has AppearEntry $.N is entry(:&coerce, :alias<normal>, :required); # (Required) The annotation’s normal appearance.
has AppearEntry $.R is entry(:&coerce, :alias<rollover>);          # (Optional) The annotation’s rollover appearance. Default value: the value of the N entry.
has AppearEntry $.D is entry(:&coerce, :alias<down>);              # (Optional) The annotation’s down appearance. Default value: the value of the N entry.
