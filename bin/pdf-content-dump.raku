#!/usr/bin/env raku
use v6;

use PDF::Class;
use PDF::Page;
use PDF::Content::Ops :OpName;

use PDF::IO;

sub MAIN(Str $infile,            #= input PDF
	 Str  :$password = '',   #= password for the input PDF, if encrypted
         Int  :$page,            #= page-number to dump
         Bool :$raku,            #= dump in a Raku-like notation
         Bool :$trace,           #= trace graphics (to stderr)
         Bool :$repair = False,  #= bypass index; recompute stream lengths
    ) {

    my $input = PDF::IO.coerce(
       $infile eq '-'
           ?? $*IN.slurp-rest( :bin ) # not random access
           !! $infile.IO
    );

    my PDF::Class $pdf .= open( $input, :$password, :$repair );

    if $page {
        dump($pdf.page($page), :$page, :$raku, :$trace);
    }
    else {
        my $page = 0;
        for $pdf.Pages.iterate-pages -> $p {
            ++$page;
            dump($p, :$page, :$raku, :$trace);
        }
    }
}

my $nesting = 0;
sub callback($op, *@args) {
    my constant Openers = 'q'|'BT'|'BMC'|'BDC'|'BX';
    my constant Closers = 'Q'|'ET'|'EMC'|'EX';
    $nesting-- if $nesting && $op ~~ Closers;
    my $pad = '  ' x $nesting;
    $nesting++ if $op ~~ Openers;
    say sprintf '%s.%s(%s);',
        $pad,
        %OpName{$op},
        @args.map(*.raku).join(", ");
}

sub dump($p, :$page, :$raku, :$trace) {
    if $raku {
        say "# **** Page $page ****";
        $p.render(:&callback);
    }
    elsif $trace {
        temp $*ERR = $*OUT;
            say "# **** Page $page ****";
            $p.render(:trace);
    }
    else {
        say "% **** Page $page ****";
        say $p.render(:comment-ops).Str;
    }
}

=begin pod

=head1 SYNOPSIS

pdf-content-dump.raku [options] --page=number file.pdf

Options:
   --password   password for an encrypted PDF
   --page=num   dump a single page (stdout)
   --raku       dump in a Raku-like notation (stdout)
   --trace      trace graphics state (to stderr)

=head1 DESCRIPTION

Dumps page content streams for a given PDF. The streams are uncompressed indented and commented for readbility.

=end pod
