unit class PDF::OCG::User;

use PDF::COS::Dict;
also is PDF::COS::Dict;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::COS::TextString;

has PDF::COS::Name $.Type is entry(:required); #= A name object that shall be either Ind (individual), Ttl (title), or Org (organization).
has PDF::COS::TextString @.Name is entry(:array-or-item, :required);      #= A text string or array of text strings representing the name(s) of the individual, position or organization.
