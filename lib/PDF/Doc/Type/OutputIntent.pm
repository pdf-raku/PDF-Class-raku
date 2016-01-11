use v6;

use PDF::DAO::Dict;
use PDF::DAO::Stream;
use PDF::Doc::Type;

# /Type /OutputIntent

class PDF::Doc::Type::OutputIntent
    is PDF::DAO::Dict
    does PDF::Doc::Type['Type', 'S'] {

}
