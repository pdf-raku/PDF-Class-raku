use v6;

#| /Action Subtype - GoTo
unit class PDF::Action::GoTo;

use PDF::Action;
use PDF::COS::Dict;
use PDF::Destination :DestDict;

also is PDF::COS::Dict;
also does DestDict;
also does PDF::Action;

use ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;
also does ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;

use ISO_32000_2::Table_202-Additional_entries_specific_to_a_go-to_action;
also does ISO_32000_2::Table_202-Additional_entries_specific_to_a_go-to_action;

