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

    method add-page(|c)    returns PDF::DOM::Type::Page { self.Pages.add-page(|c) }
    method core-font(|c)   returns PDF::DOM::Type::Font { self.Pages.core-font(|c) }
    method delete-page(|c) returns PDF::DOM::Type::Page { self.Pages.delete-page(|c) }
    method media-box(|c)   returns Array                { self.Pages.media-box(|c) }
    method page(|c)        returns PDF::DOM::Type::Page { self.Pages.page(|c) }
    method page-count      returns UInt                 { self.Pages.Count }
    method type { 'PDF' }
    method version         returns Version:_ {
	my $version = self.Root.Version;
	# reader extracts version from the PDF Header, e.g.: '%PDF-1.4'
	$version //= self.reader.version
	    if self.reader;

	$version
	    ?? Version.new( $version )
	    !! Nil
    }

    method update(|c) {
	self.cb-init
	    unless self<Root>:exists;
	self<Root>.cb-finish;

	nextsame;
    }

    method save-as($spec, Bool :$force, |c) {
	self<Root>:exists
	    ?? self<Root>.?cb-finish
	    !! die "no top-level Root entry";

	if !$force and self.reader and my $sig-flags = self.Root.?AcroForm.?SigFlags {
	    use PDF::DOM::Type::AcroForm :SigFlags;
	    die "This PDF contains digital signatures that may invalidated by a full save. Please append via the .update method, or use :force"
		if $sig-flags.flag-is-set: SigFlags::Append;
	}

	nextwith( $spec, |c);
    }

    method cb-init {
	self<Root> //= PDF::DOM::Type::Catalog.new;
    }

}
