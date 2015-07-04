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
    method Pages is rw returns PDF::DOM::Type::Pages:_ { self<Pages> }

    use PDF::DOM::Type::Outlines;
    method Outlines is rw returns PDF::DOM::Type::Outlines:_ { self<Outlines> }

    method cb-finish {
        self<Pages>.cb-finish;
    }

    method new() {
        my $obj = callsame;

        $obj<Pages> //= PDF::DOM::Type::Pages.new(
            :dict{
                :Resources{ :Procset[ :name<PDF>, :name<Text> ] },
                });

        $obj;
    }


}
