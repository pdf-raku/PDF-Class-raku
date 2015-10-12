use v6;

use PDF::DOM;
use PDF::Storage::Input::Str;
use PDF::Storage::Input::IOH;

multi sub pretty-print(DateTime $dt --> Str) {
    sprintf('%s %s %02d %02d:%02d:%02d %04d',
	    <Mon Tue Wed Thu Fri Sat Sun>[$dt.day-of-week - 1],
	    <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>[$dt.month - 1],
	    $dt.day-of-month,
	    $dt.hour, $dt.minute, $dt.second,
	    $dt.year)
}

multi sub pretty-print(Mu $val is copy --> Str) is default {
    ~$val
}

# a port of pdfinfo.pl from the Perl 5 CAM::PDF module to PDF::DOM and Perl 6

multi sub MAIN(Bool :$version! where $_) {
    # nyi in rakudo https://rt.perl.org/Ticket/Display.html?id=125017
    say "PDF::DOM {$PDF::DOM.^version}";
    say "this script was ported from the CAM::PDF PDF Manipulation library";
    say "see - https://metacpan.org/pod/CAM::PDF";
}

use PDF::Object::Int;
sub flag(PDF::Object::Int $flags, UInt $flag-num) {
    $flags.flag-is-set( $flag-num ) ?? 'yes' !! 'no';
}

multi sub MAIN(Str $file) {

    my $input = $file eq '-'
	?? PDF::Storage::Input::Str.new( :value($*IN.slurp-rest( :enc<latin-1> )) )
	!! PDF::Storage::Input::IOH.new( :value($file.IO.open( :enc<latin-1> )) );

    my $doc = PDF::DOM.open( $input );

    my UInt $size = $input.chars;
    my UInt $pages = $doc.page-count;
    my Version $pdf-version = $doc.pdf-version;
    my Hash $pdf-info = $doc.Info;
    my $box = $doc.Pages.MediaBox;
    my $encrypt = $doc.Encrypt;

    my $perms = $encrypt.P
        if $encrypt;
    $perms //= PDF::Object.coerce( :int(0xFFFF) );

    my UInt @page-size = $box
	?? ($box[2] - $box[0],  $box[3] - $box[1])
	!! (0, 0);

    say "File:         $file";
    say "File Size:    $size bytes";
    say "Pages:        $pages";
    if $pdf-info {
	for $pdf-info.keys -> $key {
	    printf "%-13s %s\n", $key ~ q{:}, pretty-print( $pdf-info{$key} );
	}
    }
    say 'Page Size:    ' ~ (@page-size[0] ?? "@page-size[0] x @page-size[1] pts" !! 'variable');
##	print 'Optimized:    '.($doc->isLinearized()?'yes':'no')."\n";
	say "PDF version:  $pdf-version";
        use PDF::Object::Type::Encrypt :Permissions;

	print "Security\n";
##	if ($prefs[0] || $prefs[1])
##	{
##	    print "  Passwd:     '$prefs[0]', '$prefs[1]'\n";
##	}
##	else
##	{
##	    print "  Passwd:     none\n";
##	}
	say '  Print:      ' ~ flag( $perms, Permissions::Print );
	say '  Modify:     ' ~ flag( $perms, Permissions::Modify );
	say '  Copy:       ' ~ flag( $perms, Permissions::Copy );
	say '  Add:        ' ~ flag( $perms, Permissions::Add );
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
-V --version        print PDF::DOM version

=head1 DESCRIPTION

Prints to STDOUT various basic details about the specified PDF
file(s).

=head1 SEE ALSO

CAM::PDF  (Perl 5)
PDF::DOM (Perl 6)

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
