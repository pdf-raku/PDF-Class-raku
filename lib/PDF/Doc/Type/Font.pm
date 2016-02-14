use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;
use PDF::Graphics::Font;

# /Type /Font - Describes a font

class PDF::Doc::Type::Font
    is PDF::DAO::Dict
    does PDF::Graphics::Font
    does PDF::Doc::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    
    my subset Name-Font of PDF::DAO::Name where 'Font';
    has Name-Font $.Type is entry(:required);
    has PDF::DAO::Name $.Subtype is entry(:required);

}

