#| /Type /Font - Describes a font
unit class PDF::Font;

use PDF::Lite;
use PDF::Class::Type;

also is PDF::Lite::Font;
also does PDF::Class::Type::Subtyped;

use PDF::COS::Tie;
use PDF::COS::Name;

has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Font';
has PDF::COS::Name $.Subtype is entry(:required, :alias<subtype>);

