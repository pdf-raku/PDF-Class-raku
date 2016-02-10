use v6;

use PDF::DAO::Stream;
use PDF::Doc::Type;

class PDF::Doc::Type::Metadata::XML
    is PDF::DAO::Stream
    does PDF::Doc::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    # See [PDF 1.7 TABLE 10.3 Additional entries in a metadata stream dictionary]
    my subset Name-Metadata of PDF::DAO::Name where 'Metadata';
    my subset Name-XML of PDF::DAO::Name where 'XML';

    has Name-Metadata $.Type is entry(:required);
    has Name-XML $.Subtype is entry(:required);
}
