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
    has PDF::DOM::Type::Pages $!Pages; method Pages { self.tie(:$!Pages) };
    method page($page-num) { self.Pages.page($page-num) }
    method pages { self.Pages.Count }
    method add-page { self.Pages.add-page }
    method delete-page($page-num) { self.Pages.delete-page($page-num) }
    method media-box(*@args) { self.Pages.media-box( |@args ) }

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
        $obj.Pages;

        $obj;
    }


}
