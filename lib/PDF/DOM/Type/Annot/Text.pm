use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    method Open is rw returns Bool:_ { self<Open> }
    method Name is rw returns Str:_ { self<Name> }
    method State is rw returns Str:_ { self<State> }
    method StateModel is rw returns Str:_ { self<StateModel> }

}
