unit class PDF::ExData::Markup3D;

use PDF::COS::Dict;
use PDF::Class::Type;
use PDF::Class::ThreeD;

also is PDF::COS::Dict;
also does PDF::Class::Type;
also does PDF::Class::ThreeD;

use ISO_32000::Table_313-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations;
also does ISO_32000::Table_313-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations;

use ISO_32000_2::Table_324-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations;
also does ISO_32000_2::Table_324-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations;

use PDF::COS::Tie;
use PDF::COS::Name;

has PDF::COS::Name  $.Type is entry(:alias<type>) where 'ExData'; # The type of PDF object that this dictionary describes; if present, is ExData for an external data dictionary.
has PDF::COS::Name  $.Subtype is entry(:required, :alias<subtype>) where 'Markup3D'; # Required) The type of external data that this dictionary describes; shall be Markup3D for a 3D comment. The only defined value is Markup3D.

has Str $.MD5 is entry; # (Optional) A 16-byte string that contains the checksum of the bytes of the 3D stream data that this 3D comment is associated with. The checksum is calculated by applying the standard MD5 message-digest algorithm to the bytes of the stream data. This value is used to determine if artwork data has changed since this 3D comment was created.
