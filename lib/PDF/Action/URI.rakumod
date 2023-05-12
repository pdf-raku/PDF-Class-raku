#| /Action Subtype - URI
unit class PDF::Action::URI;

use PDF::Action;
use PDF::COS::Dict;
also is PDF::COS::Dict;
also does PDF::Action;

use ISO_32000::Table_206-Additional_entries_specific_to_a_URI_action;
also does ISO_32000::Table_206-Additional_entries_specific_to_a_URI_action;

use PDF::COS::Tie;
use PDF::COS::ByteString;
use PDF::COS::Name;
use PDF::Class::Defs :AsciiStr;

has AsciiStr $.URI is entry(:required);   # (Required) The uniform resource identifier to resolve, encoded in 7-bit ASCII.
has Bool $.IsMap is entry;                # (Optional) A flag specifying whether to track the mouse position when the URI is resolved. Default value: false. This entry applies only to actions triggered by the user’s clicking an annotation; it shall be ignored for actions associated with outline items or with a document’s OpenAction entry.

