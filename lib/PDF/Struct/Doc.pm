use v6;

use PDF::DAO;
use PDF::DAO::Doc;

#| Doc entry-point. either a trailer dict or an XRef stream
class PDF::Struct::Doc:ver<0.0.2>
    is PDF::DAO::Doc {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::Struct::Catalog;
    has PDF::Struct::Catalog $.Root is entry(:required,:indirect);

    use PDF::Struct::Page;
    use PDF::Struct::Font;

    method Pages           returns PDF::Struct::Pages { self.Root.Pages }

    method add-page(|c)    returns PDF::Struct::Page { self.Pages.add-page(|c) }
    method core-font(|c)   returns PDF::Struct::Font { self.Pages.core-font(|c) }
    method delete-page(|c) returns PDF::Struct::Page { self.Pages.delete-page(|c) }
    method media-box(|c)   returns Array                { self.Pages.media-box(|c) }
    method page(|c)        returns PDF::Struct::Page { self.Pages.page(|c) }
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

    method save-as($spec, Bool :$force, |c) {

	if !$force and self.reader and my $sig-flags = self.Root.?AcroForm.?SigFlags {
	    use PDF::Struct::AcroForm :SigFlags;
	    die "This PDF contains digital signatures that may invalidated by a full save. Please append via the .update method, or use :force"
		if $sig-flags.flag-is-set: SigFlags::Append;
	}

	nextwith( $spec, |c);
    }

    method cb-init {
	self<Root> //= PDF::Struct::Catalog.new;
    }

}
