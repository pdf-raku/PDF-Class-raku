use v6;

use PDF::DAO;
use PDF::DAO::Doc;

#| Doc entry-point. either a trailer dict or an XRef stream
class PDF:ver<0.0.2>
    is PDF::DAO::Doc {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::Struct::Catalog;
    has PDF::Struct::Catalog $.Root is entry(:required,:indirect);

    use PDF::Struct::Page;
    use PDF::Struct::Font;

    method type { 'PDF' }
    method version returns Version:_ {
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

    method save-as($spec, Bool :$update is copy, |c) {

	if !$update and self.reader and my $sig-flags = self.Root.?AcroForm.?SigFlags {
	    use PDF::Struct::AcroForm :SigFlags;
	    if $sig-flags.flag-is-set: SigFlags::AppendOnly {
		# The document contains digital signatures that may be invalidated
		# by a full write
		with $update {
		    # callee has specified :!update
		    die "This PDF contains digital signatures that will be invalidated with .save-as :!update"
		}
		else {
		    # set :update to preserve digital signatures
		    $update = True;
		}
	    }
	}

	nextwith($spec, :$update, |c);
    }

    method cb-init {
	self<Root> //= PDF::Struct::Catalog.new;
    }

    method Pages      returns PDF::Struct::Pages { self.Root.Pages }
    #| fallback delegation to pages root; handle add-page, pages, page-count, etc...
    multi method FALLBACK(Str $meth where { self.Root.Pages.can($meth) }, |c) {
        self.WHAT.^add_method($meth,  method (|a) { self<Root><Pages>."$meth"(|a) } );
        self."$meth"(|c);
    }

    multi method FALLBACK(Str $method, |c) is default {
	die X::Method::NotFound.new( :$method, :typename(self.^name) );
    }

}
