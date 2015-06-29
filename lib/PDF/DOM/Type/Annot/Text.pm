use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    method Open is rw { self<Open> }
    method Name is rw { self<Name> }
    method State is rw { self<State> }
    method StateModel is rw { self<StateModel> }

}
