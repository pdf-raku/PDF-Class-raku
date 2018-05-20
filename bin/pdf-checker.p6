#!/usr/bin/env perl6
use v6;

use PDF::Content;
use PDF::Content::Graphics;
use PDF::Writer;

my UInt $*max-depth;
my Bool $*contents;
my Bool $*trace;
my Bool $*strict = False;
my PDF::Writer $*writer .= new;
my Str @*exclude;
my %indobj-seen;
my Int $warnings = 0;
my Int $errors = 0;

my subset Annot of Hash where .<Type> ~~ 'Annot';

sub error($msg) {
    $*ERR.say: $msg;
    $errors++;
}

sub warning($msg) {
    $*ERR.say: $msg;
    $warnings++;
}

sub ref($obj) {
    $obj.obj-num
	?? "{$obj.obj-num} {$obj.gen-num//0} R "
        !! $*writer.write($obj.content).subst(/\s+/, ' ', :g);
}

#| check a PDF against PDF class definitions
sub MAIN(Str $infile,                 #= input PDF
         Str  :$password = '',        #= password for the input PDF, if encrypted
         Str  :$class = 'PDF::Class', #= open with this class (default PDF::Class)
         Bool :$*trace,               #= show progress
         Bool :$*render,              #= validate/check contents of pages, etc
         Bool :$*strict,              #= perform additional checks
         UInt :$*max-depth = 100,     #= maximum recursion depth
	 Str  :$exclude,              #= excluded entries: Entry1,Entry2,
         Bool :$repair = False        #= repair PDF before checking
         ) {

    CONTROL {
        when CX::Warn {
            note "warning: $_";
            $warnings++;
            .resume
        }
    }
    my $doc = (require ::($class)).open( $infile, :$password, :$repair );
    @*exclude = $exclude.split(/:s ',' /)
    	      if $exclude;
    check( $doc, :ent<xref> );
    say "Checking of $infile completed with $warnings warnings and $errors errors";
}

|# Recursively check a dictionary (array) object
multi sub check(Hash $obj, UInt :$depth is copy = 0, Str :$ent = '') {
    my $obj-num = $obj.obj-num;
    return if $obj-num && %indobj-seen{"$obj-num {$obj.gen-num}"}++;
    $*ERR.say: (" " x ($depth*2)) ~ "$ent\:\t{ref($obj)} ({$obj.WHAT.^name})"
	if $*trace;
    die "maximum depth of $*max-depth exceeded $ent: {ref($obj)}"
	if ++$depth > $*max-depth;
    my Hash $entries = $obj.entries;
    my Str @unknown-entries;

    check-contents($obj)
	if $*render && $obj.does(PDF::Content::Graphics);

     my %required = $entries.pairs.grep(*.value.tied.is-required);

    for $obj.keys.sort -> $k {

        %required{$k}:delete;
        # Avoid following /P back to page then back here via page /Annots, which tends to be deeply recursive and difficult to follow
        next if $k eq 'P' && $obj ~~ Annot;
	next if @*exclude.grep: $k;
	my $kid;

	do {
	    $kid = $entries{$k}:exists
		?? $obj."$k"()   # entry has an accessor. use it
		!! $obj{$k};     # dereferece hash entry

	    CATCH {
		default {
		    error("Error in {ref($obj)} ({$obj.WHAT.^name}) /$k entry: $_");
		}
	    }
	}

	check($kid, :ent("/$k"), :$depth) if $kid ~~ Array | Hash;

	@unknown-entries.push: '/' ~ $k
	    if $*strict && +$entries && !($entries{$k}:exists);
    }

    error("Error in {ref($obj)} ({$obj.WHAT.^name}), missing required field(s): {%required.keys.sort.join(', ')}")
        if %required;

    warning("Unknown entries {ref($obj)} ({$obj.WHAT.^name}) struct: @unknown-entries[]")
        if @unknown-entries;
}

#| Recursively check an array object
multi sub check(Array $obj, UInt :$depth is copy = 0, Str :$ent = '') {
    my $obj-num = $obj.obj-num;
    return if $obj-num && %indobj-seen{"$obj-num {$obj.gen-num}"}++;

    $*ERR.say: (" " x ($depth*2)) ~ "$ent\:\t{ref($obj)} ({$obj.WHAT.^name})"
	if $*trace;
    die "maximum depth of $*max-depth exceeded $ent: {ref($obj)}"
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
		    error("error in {ref($obj)} ({$obj.WHAT.^name}) $ent: $_");
		}
	    }
	}
	check($kid, :ent("\[$_\]"), :$depth)  if $kid ~~ Array | Hash
            && !($_ == 0 && $accessor ~~ 'page'); # avoid recursing to page destinations
    }
}

multi sub check($obj) is default {}

#| check contents of a Page, XObject Form, Pattern or CharProcs
sub check-contents( $obj ) {

    # cross check with the resources directory
    my $resources = $obj.?Resources // {};

    my &callback = sub ($op, *@args) {
        my UInt $name-idx = 0;
        my Str $type = do given $op {
            when 'BDC' | 'DP' { $name-idx = 1; 'Properties'}
            when 'Do'         { 'XObject' }
            when 'Tf'         { 'Font' }
            when 'gs'         { 'ExtGState' }
            when ($_ ~~ 'scn'|'SCN')
            && @args.tail ~~ Str {
                $name-idx = $op.value.elems - 1;
                'Pattern'
            }
            when 'sh'         { 'Shading' }
            default {Nil}
        };

        with $type {
            if @args[$name-idx] ~~ Str {
                my Str $name = @args[$name-idx];
                warn "No resources /$_ /$name entry for '$op' operator"
                    unless $resources{$_}:exists && ($resources{$_}{$name}:exists);
            }
        }
    }

    my $gfx = $obj.render: :$*strict, :&callback;
    $gfx.finish;

    CATCH {
	default {
	    error("Unable to render {ref($obj)} contents: $_"); 
	}
    }
}

=begin pod

=head1 NAME

pdf-checker.p6 - Check PDF structure and values

=head1 SYNOPSIS

 pdf-checker.p6 [options] file.pdf

 Options:
   --password          password for an encrypted PDF
   --max-depth         max navigation depth (default 200)
   --trace             trace PDF navigation
   --render            check the contents streams of pages, forms, patterns and type3 fonts
   --strict            enable some additional warnings:
                       -- unknown entries in dictionarys
                       -- additional graphics checks (when --contents is enabled)
   --class <name>      checking class (default PDF::Class)
   --exclude <key>,..  restrict checking

=head1 DESCRIPTION

Checks a PDF class structure. Traverses all objects in the PDF that are accessable from the root, reporting any errors or warnings that were encountered. 

=head1 SEE ALSO

PDF

=head1 AUTHOR

See L<PDF>

=end pod
