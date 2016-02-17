use v6;

use PDF::DAO::Dict;
use PDF::Struct;

# /Type /OutputIntent

class PDF::Struct::OutputIntent
    is PDF::DAO::Dict
    does PDF::Struct['Type', 'S'] {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    my subset Name-OutputIntent of PDF::DAO::Name where 'OutputIntent';
    has Name-OutputIntent $.Type is entry;
    has PDF::DAO::Name $.S is entry(:required); #| (Required) The output intent subtype; must be GTS_PDFX for a PDF/X output intent.
    # see also PDF::Struct::OutputIntent::GTS_PDFX

}
