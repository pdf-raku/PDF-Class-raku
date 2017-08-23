use v6;

use PDF:ver(v0.2.1+);

#| PDF entry-point. either a trailer dict or an XRef stream
class PDF::Zen:ver<0.0.1> #:api<PDF-1.7>
    is PDF {

    # base class declares: $.Size, $.Encrypt, $.Info, $.ID
    use PDF::DAO::Tie;
    use PDF::Zen::Type;
    my subset Catalog of PDF::Zen::Type where { .type eq 'Catalog' };  # autoloaded PDF::Catalog
    has Catalog $.Root is entry(:required,:indirect);

    method type { 'PDF' }
    method version {
        Proxy.new(
            FETCH => sub ($) {
                Version.new: $.catalog<Version> // self.reader.?version // '1.4'
            },
            STORE => sub ($, Version $v) {
                $.catalog<Version> = name => $v.Str;
            },
        );
    }

    method open(|c) {
	my $doc = callsame;
	die "PDF file has wrong type: " ~ $doc.reader.type
	    unless $doc.reader.type eq 'PDF';
	$doc;
    }

    method save-as($spec, Bool :$preserve is copy, Bool :$info = True, |c) {

	if !$preserve and self.reader and my $sig-flags = self.Root.?AcroForm.?SigFlags {
            constant AppendOnly = 2;
	    if $sig-flags.flag-is-set: AppendOnly {
		# The document contains digital signatures that may be invalidated
		# by a full write
		with $preserve {
		    # callee has specified :!preserve
		    die "This PDF contains digital signatures that will be invalidated with .save-as :!preserve"
		}
		else {
		    # save-as(..., :preserve) to preserve digital signatures
		    $preserve = True;
		}
	    }
	}

        if $info {
            my $now = DateTime.now;
            my $Info = self.Info //= {};
            $Info.Producer //= "Perl 6 PDF::Zen {self.^ver}";
            with self.reader {
                # updating
                $Info.ModDate = $now;
            }
            else {
                # creating
                $Info.CreationDate //= $now
            }
        }
	nextwith($spec, :!info, :$preserve, |c);
    }

    method update(Bool :$info = True, |c) {
        if $info {
            # for the benefit of the test suite
            my $now = DateTime.now;
            my $Info = self.Info //= {};
            $Info.ModDate = $now;
        }
        nextsame;
    }

    method cb-init {
        unless self<Root> {
	    self<Root> = { :Type( :name<Catalog> ) };
            self<Root>.cb-init;
        }
    }

    my subset Pages of PDF::Zen::Type where { .type eq 'Pages' }; # autoloaded PDF::Pages
    method Pages returns Pages { self.Root.Pages }

    BEGIN for <page add-page delete-page page-count> {
        $?CLASS.^add_method($_, method (|a) { self<Root><Pages>."$_"(|a) } );
    }

}
