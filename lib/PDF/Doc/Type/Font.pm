use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;

# /Type /Font - Describes a font

class PDF::Doc::Type::Font
    is PDF::DAO::Dict
    does PDF::Doc::Type {

    has $.font-obj handles <encode decode filter height kern stringwidth>;

}

