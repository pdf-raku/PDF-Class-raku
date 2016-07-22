use v6;

use PDF::DAO::Dict;
use PDF::Struct;
use PDF::Content::Font;

# /Type /Font - Describes a font

class PDF::Struct::Font
    is PDF::DAO::Dict
    does PDF::Content::Font
    does PDF::Struct {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    
    my subset Name-Font of PDF::DAO::Name where 'Font';
    has Name-Font $.Type is entry(:required);
    has PDF::DAO::Name $.Subtype is entry(:required);

}

