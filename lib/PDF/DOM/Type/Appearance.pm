use v6;

use PDF::DOM::Type; # just to help rakudo
use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# AcroForm role - see PDF::DOM::Type::Catalog - /AcroForm entry

role PDF::DOM::Type::Appearance
    does PDF::DAO::Tie::Hash {

# See [PDF 1.7 TABLE 8.19 Entries in an appearance dictionary]

    use PDF::DAO;
    use PDF::DAO::Tie;
    use PDF::DAO::Stream;

    my role AppearanceOnOff
	does PDF::DAO::Tie::Hash {
	has PDF::DAO::Stream $.On;
	has PDF::DAO::Stream $.Off;
    }
    #| /Type entry is optional, but should be /Pattern when present
    my subset AppearanceEntry of PDF::DAO where PDF::DAO::Stream | AppearanceOnOff;
    multi sub coerce(Hash $dict, AppearanceEntry) {
	PDF::DAO.coerce($dict,  AppearanceOnOff)
    }

    has AppearanceEntry $.N is entry(:&coerce, :required); 
    has AppearanceEntry $.R is entry(:&coerce);
    has AppearanceEntry $.D is entry(:&coerce);

}
