use v6;

use PDF::DAO::Stream;
use PDF::Doc::Type;

# /Type /XObject - describes an abastract XObject. See also
# PDF::Doc::Type::XObject::Form, PDF::Doc::Type::XObject::Image

class PDF::Doc::Type::XObject
    is PDF::DAO::Stream
    does PDF::Doc::Type {

	use PDF::DAO::Tie;
	my subset Name-XObject of PDF::DAO::Name where 'XObject';
	has Name-XObject $.Type is entry;
	has PDF::DAO::Name  $.Subtype is entry;

}
