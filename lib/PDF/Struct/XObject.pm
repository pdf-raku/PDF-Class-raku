use v6;

use PDF::DAO::Stream;
use PDF::Struct;

# /Type /XObject - describes an abastract XObject. See also
# PDF::Struct::XObject::Form, PDF::Struct::XObject::Image

class PDF::Struct::XObject
    is PDF::DAO::Stream
    does PDF::Struct {

	use PDF::DAO::Tie;
	my subset Name-XObject of PDF::DAO::Name where 'XObject';
	has Name-XObject $.Type is entry;
	has PDF::DAO::Name  $.Subtype is entry;

}
