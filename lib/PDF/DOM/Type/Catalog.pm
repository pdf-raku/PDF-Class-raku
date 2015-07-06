use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;
use PDF::DOM::RootObject;
use PDF::DOM::Resources;

# /Type /Catalog - usually the root object in a PDF

class PDF::DOM::Type::Catalog
    is PDF::Object::Dict
    does PDF::DOM::Type
    does PDF::DOM::RootObject
    does PDF::DOM::Resources {

    use PDF::DOM::Type::Pages;
    has PDF::DOM::Type::Pages:_ $!Pages; method Pages { self.tie(:$!Pages) };

    use PDF::DOM::Type::Outlines;
    has PDF::DOM::Type::Outlines:_ $!Outlines; method Outlines { self.tie(:$!Outlines) };

    method cb-finish {
        self<Pages>.cb-finish;
    }

    method new() {
        my $obj = callsame;

        # vivify pages
        $obj<Pages> //= PDF::DOM::Type::Pages.new(
            :dict{
                :Resources{ :Procset[ :name<PDF>, :name<Text> ] },
                :Count(0),
                :Kids[],
                });

        $obj;
    }


}
