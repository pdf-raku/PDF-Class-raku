use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::OutputIntent
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;

    has Str $.OutputCondition is entry;
    has Str $.OutputConditionIdentifier is entry;
    has Str $.RegistryName is entry;
    has Str $.Info is entry;
    has PDF::Object::Stream $.DestOutputProfile is entry;

}
