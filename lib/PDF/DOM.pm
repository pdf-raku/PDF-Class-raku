use v6;

class PDF::DOM {...}

use PDF::DAO;
use PDF::DAO::Doc;

#| DOM entry-point. either a trailer dict or an XRef stream
class PDF::DOM
    is PDF::DAO::Doc {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::DOM::Type::Catalog;
    has PDF::DOM::Type::Catalog $.Root is entry(:required,:indirect);

    use PDF::DOM::Type::Page;
    use PDF::DOM::Type::Font;

    method Pages           returns PDF::DOM::Type::Pages { self.Root.Pages }

    method add-page        returns PDF::DOM::Type::Page { self.Pages.add-page }
    method core-font(|c)   returns PDF::DOM::Type::Font { self.Pages.core-font(|c) }
    method delete-page(|c) returns PDF::DOM::Type::Page { self.Pages.delete-page(|c) }
    method media-box(|c)   returns Array                { self.Pages.media-box(|c) }
    method page(|c)        returns PDF::DOM::Type::Page { self.Pages.page(|c) }
    method page-count      returns UInt                 { self.Pages.Count }
    method pdf-version     returns Version:_ {
	my $version = self.Root.Version;
	# reader extracts version from the PDF Header, e.g.: '%PDF-1.4'
	$version //= self.reader.version
	    if self.reader;

	$version
	    ?? Version.new( $version )
	    !! Nil
    }

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
