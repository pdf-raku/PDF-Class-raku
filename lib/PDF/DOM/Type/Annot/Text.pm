use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    has Bool:_ $!Open; method Open { self.tie(:$!Open) };
    has Str:_ $!Name; method Name { self.tie(:$!Name) };
    has Str:_ $!State; method State { self.tie(:$!State) };
    has Str:_ $!StateModel; method StateModel { self.tie(:$!StateModel) };

}
