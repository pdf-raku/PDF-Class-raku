use v6;

use PDF::DOM;
use PDF::DOM::Type::Annot;
my UInt $*max-depth;
my Bool $*trace;
my Bool $*strict;
my %seen;

multi sub validate(Hash $obj, :$depth is copy = 0, :$ent = '') {
    return if %seen{$obj.id}++;
    my $ref = "{$obj.obj-num} {$obj.gen-num//0} R "
        if $obj.obj-num;
    $*ERR.say: (" " x ($depth*2)) ~ "$ent\:\t" ~ ($ref // ' ' ) ~ $obj.id
	if $*trace;
    die "maximum depth of $*max-depth exceeded"
	if ++$depth > $*max-depth;
    my Hash $entries = $obj.entries;
    my @unknown-entries;

    for $obj.keys.sort {

        # Avoid following /P back to page then back here via page /Annots
        next if $_ eq 'P' && $obj.isa(PDF::DOM::Type::Annot);

	my $kid;

	do {
	    $kid = $entries{$_}:exists
		?? $obj."$_"()   # entry has an accessor. use it
		!! $obj{$_};     # dereferece hash entry

	    CATCH {
		default {
		    $*ERR.say: "error in {$ref//' '}$ent entry: $_"; 
		}
	    }
	}

	validate($kid, :ent("/$_"), :$depth) if $kid ~~ Array | Hash;

	@unknown-entries.push( '/' ~ $_ )
	    if $*strict && +$entries && !($entries{$_}:exists);
    }
    $*ERR.say: "unknown entries in {$ref//' '}{$obj.WHAT.gist} struct: @unknown-entries[]"
	if @unknown-entries && $obj.WHAT.gist ~~ /'PDF::' .*? '::Type'/; 
}

multi sub validate(Array $obj, :$depth is copy = 0, :$ent = '') {
    return if %seen{$obj.id}++;
    my $ref = "{$obj.obj-num} {$obj.gen-num//0} R "
        if $obj.obj-num;
    $*ERR.say: (" " x ($depth*2)) ~ "$ent\:\t" ~ ($ref // '' ) ~ $obj.id
	if $*trace;
    die "maximum depth of $*max-depth exceeded"
	if ++$depth > $*max-depth;
    my Array $index = $obj.index;
    for $obj.keys.sort {
	my Str $accessor = $index[$_].tied.accessor-name
	    if $index[$_]:exists;
	my $kid;
	do {
	    $kid = $accessor
		?? $obj."$accessor"()  # array element has an accessor. use it
		!! $obj[$_];           # dereference array element

	    CATCH {
		default {
		    $*ERR.say: "error in {$ref//' '}$ent: $_"; 
		}
	    }
	}
	validate($kid, :ent("\[$_\]"), :$depth)  if $kid ~~ Array | Hash;
    }
}
multi sub validate($obj) is default {}

sub MAIN(Str $infile, UInt :$*max-depth = 100, Bool :$*trace, Bool :$*strict) {

    my $doc = PDF::DOM.open: $infile;
    validate( $doc, :ent<xref> );

}
=begin pod

=head1 NAME

pdf-validate.p6 - Validate PDF DOM structure

=head1 SYNOPSIS

 pdf-validator.p6 [options] file.pdf

 Options:
   --max-depth  max DOM navigation depth (default 100)
   --trace      trace DOM navigation
   --strict     report on unknown dictionary entrys

=head1 DESCRIPTION

Performs validation on a PDF. Traverses all objects in the PDF that are accessable from the root,
reporting any errors or warnings that were encountered. 

=head1 SEE ALSO

PDF::DOM

=head1 AUTHOR

See L<PDF::DOM>

=end pod
