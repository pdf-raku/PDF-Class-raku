use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;
use PDF::DOM::Resources;

# /Type /Catalog - usually the document root in a PDF

class PDF::DOM::Type::Catalog
    is PDF::Object::Dict
    does PDF::DOM::Type
    does PDF::DOM::Resources {

    use PDF::Object::Tie;
    use PDF::DOM::Type::Pages;
    has PDF::DOM::Type::Pages $!Pages is tied;

    use PDF::DOM::Type::Outlines;
    has PDF::DOM::Type::Outlines:_ $!Outlines is tied;

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
