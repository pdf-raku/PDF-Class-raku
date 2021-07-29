use v6;

use PDF::Action;
use PDF::COS::Dict;

#| /Action Subtype - GoTo
class PDF::Action::GoTo
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;
    # also does ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Destination :DestRef, :coerce-dest;
    has DestRef $.D is entry(:required, :alias<destination>, :coerce(&coerce-dest));    # (Required) The destination to jump to

}
