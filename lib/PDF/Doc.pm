use v6;

use PDF::DAO;
use PDF::DAO::Doc;

#| Doc entry-point. either a trailer dict or an XRef stream
class PDF::Doc:ver<0.0.2>
    is PDF::DAO::Doc {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::Doc::Type::Catalog;
    has PDF::Doc::Type::Catalog $.Root is entry(:required,:indirect);

    use PDF::Doc::Type::Page;
    use PDF::Doc::Type::Font;

    method Pages           returns PDF::Doc::Type::Pages { self.Root.Pages }

    method add-page(|c)    returns PDF::Doc::Type::Page { self.Pages.add-page(|c) }
    method core-font(|c)   returns PDF::Doc::Type::Font { self.Pages.core-font(|c) }
    method delete-page(|c) returns PDF::Doc::Type::Page { self.Pages.delete-page(|c) }
    method media-box(|c)   returns Array                { self.Pages.media-box(|c) }
    method page(|c)        returns PDF::Doc::Type::Page { self.Pages.page(|c) }
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

    method open(|c) {
	my $doc = callsame;
	die "PDF file has wrong type: " ~ $doc.reader.type
	    unless $doc.reader.type eq 'PDF';
	$doc;
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
	    use PDF::Doc::Type::AcroForm :SigFlags;
	    die "This PDF contains digital signatures that may invalidated by a full save. Please append via the .update method, or use :force"
		if $sig-flags.flag-is-set: SigFlags::Append;
	}

	nextwith( $spec, |c);
    }

    method cb-init {
	self<Root> //= PDF::Doc::Type::Catalog.new;
    }

}
