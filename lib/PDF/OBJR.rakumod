use v6;

#| /Type /OBJR - Object Reference dictionary
unit class PDF::OBJR;

use PDF::COS::Dict;
use PDF::Class::Type;

also is PDF::COS::Dict;
also does PDF::Class::Type;

use ISO_32000::Table_325-Entries_in_an_object_reference_dictionary;
also does ISO_32000::Table_325-Entries_in_an_object_reference_dictionary;
use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Page;
use PDF::Class::StructItem;

has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'OBJR';
has PDF::Page $.Pg is entry(:indirect, :alias<page>);       # (Optional; must be an indirect reference) The page object representing the page on which the object is rendered. This entry overrides any Pg entry in the structure element containing the object reference; it is required if the structure element has no such entry.
has PDF::Class::StructItem $.Obj is entry(:required,:indirect,:alias<object>); # (Required; must be an indirect reference) The referenced object.
