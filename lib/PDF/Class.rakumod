use v6;

use PDF:ver(v0.3.8+);

#| PDF entry-point. either a trailer dict or an XRef stream
class PDF::Class:ver<0.4.3>#:api<PDF-1.7>
    is PDF {
    # base class declares: $.Size, $.Encrypt, $.ID
    # use ISO_32000::Table_15-Entries_in_the_file_trailer_dictionary;
    # also does ISO_32000::Table_15-Entries_in_the_file_trailer_dictionary;

    use PDF::Content;
    use PDF::COS::Tie;
    use PDF::Class::Type;
    use PDF::Info;
    has PDF::Info $.Info is entry(:indirect);  # (Optional; must be an indirect reference) The document’s information dictionary
    my subset CatalogLike of PDF::Class::Type where { .<Type> ~~ 'Catalog' };  # autoloaded PDF::Catalog
    has CatalogLike $.Root is entry(:required, :indirect, :alias<catalog>);

    method type { 'PDF' }
    method version is rw {
        Proxy.new(
            FETCH => {
                Version.new: $.catalog<Version> // self.?reader.?version // '1.4'
            },
            STORE => -> $, Version $_ {
                my $name = .Str;
                $.catalog<Version> = PDF::COS.coerce: :$name;
            },
        );
    }

    # make sure it really is a PDF, not an FDF file etc
    method open(|c) { nextwith( :type<PDF>, |c); }

    method save-as($spec, Bool :$info = True, |c) {

        if $info {
            my $now = DateTime.now;
            my $Info = self.Info //= {};
            with self.reader {
                # updating
                $Info.ModDate = $now;
            }
            else {
                # creating
                my @creator = "PDF::Class-{PDF::Class.^ver}", "PDF::Content-{PDF::Content.^ver}", "PDF-{PDF.^ver}", "Raku-{$*PERL.version}";
                $Info.Producer  //= "{self.WHAT.perl}{with self.^ver { "-$_" } else { '' }}";
                $Info.Creator   //= @creator.join: ', ';
                $Info.CreationDate //= $now
            }
        }
	nextwith($spec, :!info, |c);
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

    # permissions check, e.g: $doc.permitted( PermissionsFlag::Modify )
    method permitted(UInt $flag --> Bool) {

	my Int $perms = self.Encrypt.?P
	    // return True;

	return True
	    if $.crypt.?is-owner;

	return $perms.flag-is-set( $flag );
    }

    method cb-init {
        unless self<Root> {
	    self<Root> = { :Type( :name<Catalog> ) };
            self<Root>.cb-init;
        }
    }

    my subset PagesLike of PDF::Class::Type where { .<Type> ~~ 'Pages' }; # autoloaded PDF::Pages
    method Pages returns PagesLike handles <page pages add-page delete-page insert-page page-count page-index media-box crop-box bleed-box trim-box art-box core-font use-font rotate> { self.Root.Pages }

}
