use v6;

use PDF;

#| PDF entry-point. either a trailer dict or an XRef stream
class PDF::Class:ver<0.5.6>
    is PDF {
    # base class declares: $.Size, $.Encrypt, $.ID
    # use ISO_32000::Table_15-Entries_in_the_file_trailer_dictionary;
    # also does ISO_32000::Table_15-Entries_in_the_file_trailer_dictionary;

    use PDF::COS::Util :&flag-is-set;
    use PDF::Content;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Class::Type;
    use PDF::Info;
    use PDF::Content::Font::CoreFont;

    has PDF::Info $.Info is entry(:indirect);  #= (Optional; must be an indirect reference) The document’s information dictionary
    my subset CatalogLike of PDF::Class::Type where { .<Type> ~~ 'Catalog' };  # autoloaded PDF::Catalog
    has CatalogLike $.Root is entry(:required, :indirect, :alias<catalog>); #= The catalog dictionary for the PDF document contained in the file

    method type { 'PDF' }
    method version is rw {
        Proxy.new(
            FETCH => {
                Version.new: $.catalog<Version> // self.?reader.?version // '1.4'
            },
            STORE => -> $, Version $_ {
                my $name = .Str;
                $.catalog<Version> = PDF::COS::Name.COERCE: $name;
            },
        );
    }

    # make sure it really is a PDF, not an FDF file etc
    method open(|c) { nextwith( :$.type, |c); }

    has Str @.creator = "PDF::Class-{PDF::Class.^ver}", "PDF::Content-{PDF::Content.^ver}", "PDF-{PDF.^ver}", "Raku-{$*RAKU.version}";

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
                $Info.Producer  //= "{self.^name}{with self.^ver { "-$_" } else { '' }}";
                $Info.Creator   //= @!creator.join: '; ';
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
	my Int $perms = .P
           with self.Encrypt;

	!$perms.defined || $.crypt.?is-owner
            ?? True
	    !! $perms.&flag-is-set( $flag );
    }

    has PDF::Content::Font::CoreFont::Cache $!cache .= new;
    method core-font(|c) {
        PDF::Content::Font::CoreFont.load-font(:$!cache, |c);
    }

    method cb-init {
        unless self<Root> {
	    self<Root> = { :Type( :name<Catalog> ) };
            self<Root>.cb-init;
        }
    }

    my subset PagesLike of PDF::Class::Type where { .<Type> ~~ 'Pages' }; # autoloaded PDF::Pages
    method Pages returns PagesLike handles <page pages add-page add-pages delete-page insert-page page-count media-box crop-box bleed-box trim-box art-box use-font rotate iterate-pages> { self.Root.Pages }

    method fields {
        do with self.Root.AcroForm { .fields } // [];
    }
    method fields-hash(|c) {
        do with self.Root.AcroForm { .fields-hash(|c) } // %();
    }
}

=begin pod

=head2 Synopsis
    =begin code :lang<raku>
    use PDF::Class;
    use PDF::Catalog;
    use PDF::Page;
    use PDF::Info;

    my PDF::Class $pdf .= open: "t/helloworld.pdf";

    # vivify Info entry; set title
    given $pdf.Info //= {} -> PDF::Info $_ {
        .Title = 'Hello World!';
        .ModDate = DateTime.now; # PDF::Class sets this anyway...
    }

    # modify Viewer Preferences
    my PDF::Catalog $catalog = $pdf.Root;
    given $catalog.ViewerPreferences //= {} {
        .HideToolbar = True;
    }

    # add a page ...
    my PDF::Page $new-page = $pdf.add-page;
    $new-page.gfx.say: "New last page!";

    # save the updated pdf
    $pdf.save-as: "tmp/pdf-updated.pdf";
    =end code

=head2 Description

This is the base class for opening or creating a document as a PDF class.
the document can then be manipulated as a library of classes that represent
the majority of objects that can be found in a PDF file.

=end pod
