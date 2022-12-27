unit class PDF::Metadata::XML;

use PDF::COS::Stream;
use PDF::Class::Type;
also is PDF::COS::Stream;
also does PDF::Class::Type::Subtyped;

# use ISO_32000::Table_315-Additional_entries_in_a_metadata_stream_dictionary;
# also does ISO_32000::Table_315-Additional_entries_in_a_metadata_stream_dictionary;

use PDF::COS::Tie;
use PDF::COS::Name;

has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Metadata';
has PDF::COS::Name $.Subtype is entry(:required, :alias<subtype>) where 'XML';
has PDF::Metadata::XML $.Metadata is entry; # (Optional; PDF 1.4) A metadata stream containing metadata for the component.
