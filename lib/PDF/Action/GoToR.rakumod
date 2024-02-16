#| /Action Subtype - GoToR
unit class PDF::Action::GoToR;

use PDF::COS::Dict;
use PDF::Action;

also is PDF::COS::Dict;
also does PDF::Action;

use ISO_32000::Table_200-Additional_entries_specific_to_a_remote_go-to_action;
also does ISO_32000::Table_200-Additional_entries_specific_to_a_remote_go-to_action;

use ISO_32000_2::Table_203-Additional_entries_specific_to_a_remote_go-to_action;
also does ISO_32000_2::Table_203-Additional_entries_specific_to_a_remote_go-to_action;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Destination :DestRef, :RemoteDestRef, :DestinationLike, :&coerce-dest;
use PDF::Filespec :FileRef, :FileRefLike, :&to-file;
use PDF::Page;

has FileRef $.F is entry(:alias<file>, :required, :coerce(&to-file)); # (Required) The file in which the destination shall be located.
has RemoteDestRef $.D is entry(:required, :alias<destination>, :coerce(&coerce-dest)); # (Required) The destination to jump to. If the value is an array defining an explicit destination, its first element shall be a page number within the remote document rather than an indirect reference to a page object in the current document. The first page shall be numbered 0.
has PDF::COS::Array $.SD is entry; # (Optional; PDF 2.0) The structure destination to jump to. The first element in the arrayis a byte string representing a structure element ID in the remote document, instead of an indirect reference to a structure element dictionary.
has Bool $.NewWindow is entry; # (Optional; PDF 1.2) A flag specifying whether to open the destination document in a new window. If this flag is false, the destination document replaces the current document in the same window. If this entry is absent, the conforming reader should behave in accordance with its preference.

