use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;

# /Type /Font - Describes a font

class PDF::Doc::Type::Font
    is PDF::DAO::Dict
    does PDF::Doc::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    
    my subset Name-Font of PDF::DAO::Name where 'Font';
    has Name-Font $.Type is entry(:required);
    has PDF::DAO::Name $.Subtype is entry(:required);

    has $.font-obj handles <encode decode filter height kern stringwidth>;

}

