use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::OutputIntent
    is PDF::Object::Dict
    does PDF::DOM::Type {

    has Str:_ $!OutputCondition; method OutputCondition { self.tie(:$!OutputCondition) };
    has Str:_ $!OutputConditionIdentifier; method OutputConditionIdentifier { self.tie(:$!OutputConditionIdentifier) };
    has Str:_ $!RegistryName; method RegistryName { self.tie(:$!RegistryName) };
    has Str:_ $!Info; method Info { self.tie(:$!Info) };
    has PDF::Object::Stream:_ $!DestOutputProfile; method DestOutputProfile { self.tie(:$!DestOutputProfile) };

}
