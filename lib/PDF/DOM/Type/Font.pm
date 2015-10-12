use v6;

use PDF::DAO::Dict;
use PDF::DOM::Type;

# /Type /Font - Describes a font

class PDF::DOM::Type::Font
    is PDF::DAO::Dict
    does PDF::DOM::Type {

    has $.font-obj handles <encode decode filter height kern stringwidth>;

}

