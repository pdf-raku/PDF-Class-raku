use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::OutputIntent
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Str:_ $!OutputCondition is tied;
    has Str:_ $!OutputConditionIdentifier is tied;
    has Str:_ $!RegistryName is tied;
    has Str:_ $!Info is tied;
    has PDF::Object::Stream:_ $!DestOutputProfile is tied;

}
