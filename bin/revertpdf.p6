use v6;
use PDF::DOM;

sub MAIN(Str $infile, Str $outfile = $infile, Bool :$count, Str :$password = '') {

    my $input = $infile eq q{-}
        ?? $*IN
	!! $infile;

    my $doc = PDF::DOM.open( $input, :$password);

    my UInt $revs = + $doc.reader.xrefs;

    if $count {
	say $revs;
    }
    elsif $revs < 1 {
	die "Error: this does not seem to be a PDF document\n";
    }
    elsif $revs == 1 {
	die "Error: there is only one revision in this PDF document.  It cannot be reverted.\n";
    }
    else {
        constant EOF-MARKER = '%%EOF';
        my UInt $prev = $doc.reader.xrefs[*-2];
	my Str $body = $doc.reader.input.substr(0, $prev);
	my Str $tail = $doc.reader.input.substr($prev);
        my UInt $eof-index = $tail.index(EOF-MARKER)
            // die "Cannot find the end-of-file marker\n";
        my Str $xref = $tail.substr(0, $eof-index + EOF-MARKER.chars);

	my $fh = $outfile eq q{-}
	   ?? $*OUT
	   !! $outfile.IO.open( :w, :enc<latin-1> );

	$fh.print: $body;
	$fh.print: $xref;
	$fh.close;
    }
}


=begin pod

=head1 NAME

revertpdf.pl - Remove the last edits to a PDF document

=head1 SYNOPSIS

 revertpdf.pl [options] infile.pdf [outfile.pdf]

 Options:
   -c --count          just print the number of revisions and exits

=head1 DESCRIPTION

PDF documents have the interesting feature that edits can be applied
just to the end of the file without altering the original content.
This makes it possible to recover previous versions of a document.
This is only possible if the editor writes out an 'unoptimized'
version of the PDF.

This program removes the last layer of edits from the PDF document.  If
there is just one revision, we emit a message and abort.

The C<--count> option just prints the number of generations the document
has endured and applies no changes.

=head1 SEE ALSO

CAM::PDF

=head1 AUTHOR

See L<CAM::PDF>

=end pod
