use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::OutputIntent
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method S is rw returns Str { self<S> }
    method OutputCondition is rw returns Str:_ { self<OutputCondition> }
    method OutputConditionIdentifier is rw returns Str:_ { self<OutputConditionIndentifier> }
    method RegistryName is rw returns Str:_ { self<RegistryName> }
    method Info is rw returns Str:_ { self<Info> }
    method DestOutputProfile is rw returns PDF::Object::Stream:_ { self<DestOutputProfile> }

}
