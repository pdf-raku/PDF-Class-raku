use v6;

use PDF::DOM;
use PDF::Storage::Input::Str;
use PDF::Storage::Input::IOH;

# a port of pdfinfo.pl from the Perl 5 CAM::PDF module to PDF::DOM and Perl 6

multi sub MAIN(Bool :$version! where $_) {
    # nyi in rakudo https://rt.perl.org/Ticket/Display.html?id=125017
    say "DOM::PDF {$DOM::PDF.^version}";
    say "this script was ported from the CAM::PDF PDF Manipulation library";
    say "see - https://metacpan.org/pod/CAM::PDF";
}

multi sub MAIN(Str $file) {

    my $input = $file eq '-'
	?? PDF::Storage::Input::Str.new( :value($*IN.slurp-rest( :enc<latin-1> )) )
	!! PDF::Storage::Input::IOH.new( :value($file.IO.open( :enc<latin-1> )) );

    my $doc = PDF::DOM.open( $input );

    my UInt $size = $input.chars;
    my UInt $pages = $doc.page-count;
##	my @prefs = $doc->getPrefs();
    my Version $pdf-version = $doc.pdf-version;
    my Hash $pdf-info = $doc<Info>;
    my $box = $doc.Pages<MediaBox>;
    my UInt @page-size = $box
	?? ($box[2] - $box[0],  $box[3] - $box[1])
	!! (0, 0);

    say "File:         $file";
    say "File Size:    $size bytes";
    say "Pages:        $pages";
    if $pdf-info {
	for $pdf-info.keys -> $key {
	    my Str $val = $pdf-info{$key};
	    if $val ~~ m{'D:' $<year>=\d**4 $<month>=\d**2 $<day>=\d**2 $<hour>=\d**2 $<min>=\d**2 $<sec>=\d**2
			      $<tz-sign>=< + - Z > $<tz-hour>=\d**2 \' $<tz-min>=\d**2 \' } {

		my Str $iso-date = sprintf("%04d-%02d-%02dT%02d:%0d:%02d", $<year>, $<month>, $<day>, $<hour>, $<min>, $<sec> )
		    ~ ($<tz-sign> eq 'Z'
		       ?? 'Z'
		       !! sprintf '%s%02d%0d2', $<tz-sign>, $<tz-hour>, $<tz-min> );

		my $dt = DateTime.new: $iso-date;

		$val = sprintf('%s %s %02d %02d:%02d:%02d %04d',
			       <Mon Tue Wed Thu Fri Sat Sun>[$dt.day-of-week - 1],
			       <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>[$dt.month - 1],
			       $dt.day-of-month,
			       $dt.hour, $dt.minute, $dt.second,
			       $dt.year);

	    }
	    printf "%-13s %s\n", $key ~ q{:}, $val;
	}
    }
    say 'Page Size:    ' ~ (@page-size[0] ?? "@page-size[0] x @page-size[1] pts" !! 'variable');
##	print 'Optimized:    '.($doc->isLinearized()?'yes':'no')."\n";
	say "PDF version:  $pdf-version";
##	print "Security\n";
##	if ($prefs[0] || $prefs[1])
##	{
##	    print "  Passwd:     '$prefs[0]', '$prefs[1]'\n";
##	}
##	else
##	{
##	    print "  Passwd:     none\n";
##	}
##	print '  Print:      '.($prefs[2]?'yes':'no')."\n";
##	print '  Modify:     '.($prefs[3]?'yes':'no')."\n";
##	print '  Copy:       '.($prefs[4]?'yes':'no')."\n";
##	print '  Add:        '.($prefs[5]?'yes':'no')."\n";
##	if (@ARGV > 0)
##	{
##	    print "---------------------------------\n";
##	}

}

=begin pod

=head1 NAME

pdfinfo.pl - Print information about PDF file(s)

=head1 SYNOPSIS

pdfinfo.pl [options] file.pdf [file.pdf ...]

Options:
-v --verbose        print diagnostic messages
-h --help           verbose help message
-V --version        print CAM::PDF version

=head1 DESCRIPTION

Prints to STDOUT various basic details about the specified PDF
file(s).

=head1 SEE ALSO

CAM::PDF

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
