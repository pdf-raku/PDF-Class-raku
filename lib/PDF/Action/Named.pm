use v6;

use PDF::Action;
use PDF::COS::Dict;

#| /Action Subtype - GoTo

class PDF::Action::Named
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_212-Additional_entries_specific_to_named_actions;
    # also does ISO_32000::Table_212-Additional_entries_specific_to_named_actions;

    use PDF::COS::Tie;
    use PDF::COS::Name;

    my subset ActionName of PDF::COS::Name where 'NextPage'|'PrevPage'|'FirstPage'|'LastPage';
    has ActionName $.N is entry(:required, :alias<action-name>); # (Required) The name of the action that shall be performed.

}
