use v6;

class PDF::DOM {...}

use PDF::Object;
use PDF::Object::Doc;

#| DOM entry-point. either a trailer dict or an XRef stream
class PDF::DOM
    is PDF::Object::Doc {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::Object::Tie;
    use PDF::DOM::Type::Catalog;
    has PDF::DOM::Type::Catalog $.Root is entry(:required,:indirect);

    method Pages { self.Root.Pages }
    method page($page-num) { self.Pages.page($page-num) }
    method page-count { self.Pages.Count }
    method add-page { self.Pages.add-page }
    method delete-page($page-num) { self.Pages.delete-page($page-num) }
    method media-box(*@a) { self.Pages.media-box( |@a ) }
    method core-font(*@a, *%o) { self.Pages.core-font( |@a, |%o ) }

    method update(|c) {
	self<Root>:exists
	    ?? self<Root>.?cb-finish
	    !! warn "no top-level Root entry";

	nextsame;
    }

    method save-as(|c) {
	self<Root>:exists
	    ?? self<Root>.?cb-finish
	    !! warn "no top-level Root entry";

	nextsame;
    }

    method cb-init {
	self<Root> //= PDF::DOM::Type::Catalog.new;
    }

}
