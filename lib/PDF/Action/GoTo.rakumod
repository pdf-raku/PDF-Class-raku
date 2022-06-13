use v6;

use PDF::Action;
use PDF::COS::Dict;
use PDF::Destination :DestDict, :DestRef, :LocalDestRef, :DestinationLike, :&coerce-dest;

#| /Action Subtype - GoTo
class PDF::Action::GoTo
    is PDF::COS::Dict
    does DestDict
    does PDF::Action {

    # use ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;
    # also does ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action;
    use PDF::COS::Name;

    method construct(DestinationLike:D :$destination!) {
        my LocalDestRef $D = coerce-dest($destination, DestRef);
        my PDF::COS::Name() $Type = 'Action';
        my PDF::COS::Name() $S = 'GoTo';
        self.COERCE: %( :$Type, :$S, :$D );
    }
}
