use v6;

use PDF::DAO::Type::PDF;

#| Doc entry-point. either a trailer dict or an XRef stream
class PDF:ver<0.0.3>
    is PDF::DAO::Type::PDF {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::Catalog;
    has PDF::Catalog $.Root is entry(:required,:indirect);

    method type { 'PDF' }
    method version returns Version:_ {
	my $version = self.Root.Version;
	# reader extracts version from the PDF Header, e.g.: '%PDF-1.4'
	$version //= .version
	    with self.reader;

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
	    use PDF::AcroForm :SigFlags;
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
	self<Root> //= PDF::Catalog.new;
    }

    use PDF::Pages;
    method Pages returns PDF::Pages { self.Root.Pages }

    for <page add-page page-count> {
        $?CLASS.^add_method($_, method (|a) { self<Root><Pages>."$_"(|a) } );
    }

}
