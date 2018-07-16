#!/usr/bin/env perl6
use v6;

use PDF::Class;
use PDF::Catalog;
use PDF::Outline; # outline root
use PDF::Outlines; # outline entries
use PDF::Destination :DestinationArray, :coerce-dest;
use PDF::Action::URI;

use PDF::IO::Str;
use PDF::IO::Handle;
use PDF::COS;

my $dests;

my subset IndRef of Pair where {.key eq 'ind-ref'};
sub ind-ref(IndRef $_ ) {
      (.value[0], .value[1], 'R').join: ' ';
}

my %page-index;

sub MAIN(Str $infile,           #| input PDF
	 Str :$password = '',   #| password for the input PDF, if encrypted
    ) {

    my $input = $infile eq '-'
	?? PDF::IO::Str.new( :value($*IN.slurp-rest( :enc<latin-1> )) )
	!! PDF::IO::Handle.new( :value($infile.IO.open( :enc<latin-1> )) );

    my PDF::Class $pdf .= open( $input, :$password );

    my @index = $pdf.catalog.Pages.page-index;
    %page-index = @index.pairs.map: {
        ind-ref(.value) => .key + 1
    }
    $dests = $pdf.catalog.Dests
     // do with $pdf.catalog.Names {
        .names with .Dests;
    } // {};

    with $pdf.catalog.Outlines {
        toc-children($_, :nesting(0));
    }
    else {
        note "document does not contain outlines: $infile";
    }
}

multi sub show-dest(Str $_) {
    show-dest($dests{$_});
}

multi sub show-dest(Hash $deref where .<D>.defined) {
    show-dest($deref<D>);
}

multi sub show-dest(IndRef $_) {
    my $ref = ind-ref($_);
    %page-index{$ref}  // $ref;
}

multi sub show-dest(DestinationArray $_) {
    show-dest(.values[0]);
}

multi sub show-dest($_) is default {
    Nil
}


sub toc($outline, :$nesting!) {
    my $where = do with $outline.Dest // $outline.A { show-dest($_) };
    with $where {
        say( ('  ' x $nesting) ~ $outline.Title ~ ' . . . ' ~ $_);
        toc-children($outline, :nesting($nesting+1));
    }
}

sub toc-children($_, :$nesting!) {
    my $node = .First;
    while $node.defined {
        toc($node, :$nesting);
        $node = $node.Next;
    }
}

=begin pod

=head1 SYNOPSIS

pdf-toc.p6 [options] file.pdf

Options:
   --password   password for an encrypted PDF

=head1 DESCRIPTION

Prints a table of contents for a given PDF.

=end pod
