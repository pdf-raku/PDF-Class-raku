#!/usr/bin/env perl6
use v6;

use PDF::Class;
use PDF::Page;

use PDF::IO::Str;
use PDF::IO::Handle;

sub MAIN(Str $infile,           #= input PDF
	 Str :$password = '',   #= password for the input PDF, if encrypted
         Int :$page,            #= page-number to dump
         Bool :$strict = False, #= enable extra rendering warnings
    ) {

    my $input = $infile eq '-'
	?? PDF::IO::Str.new( :value($*IN.slurp-rest( :enc<latin-1> )) )
	!! PDF::IO::Handle.new( :value($infile.IO.open( :enc<latin-1> )) );

    my PDF::Class $pdf .= open( $input, :$password );

    for 1 .. $pdf.page-count {
        next if $page && $_ != $page;
        say "% **** Page $_ ****";
        say $pdf.page($_).render(:comment-ops).Str;
    }
}

=begin pod

=head1 SYNOPSIS

pdf-content-dump.p6 [options] --page=number file.pdf

Options:
   --password   password for an encrypted PDF
   --/title     disable printing of title (if present)
   --/labels    display raw page numbers

=head1 DESCRIPTION

Dumps page content streams for a given PDF. The streams are uncompressed indented and commented for readbility. 

=end pod
