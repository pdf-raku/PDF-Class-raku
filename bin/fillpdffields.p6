use v6;

use PDF::DOM;
use PDF::DAO::Type::Encrypt :PermissionsFlag;

#| set specified fields from name-value pairs
multi sub MAIN(
    Str $infile,
    Str $outfile,
    Bool :$trigger-clear,
    Str  :$background,
    *@field-list) {
    
    die "last field lacks a value: @field-list[*-1]"
	unless +@field-list %% 2;

##if ($opts{background} =~ m/\s/xms)
##{
##   # Separate r,g,b
##   $opts{background} = [split m/\s+/xms, $opts{background}];
##}

    my $doc = PDF::DOM.open($infile);
    my %fields = $doc.Root.AcroForm.fields-hash
	if $doc.Root.?AcroForm;

    for @field-list -> $key, $val {
	if %fields{$key}:exists {
	    # CAM::PDF is working harder here and resizing/styling the field to accomodate the field value
	    # todo: port CAM::PDF::fillFormFields sub. fill-form method in PDF::DOM::Type::Field?
	    %fields{$key}.V = $val;
	    %fields{$key}<AA>:delete
		if $trigger-clear;
	}
	else {
	    warn "no such field: $key. Use --list to display fields";
	}
    }

    die "This PDF forbids modification\n"
	unless $doc.permitted( PermissionsFlag::Modify );
    $doc.save-as($outfile);
}

#| list all fields and current values
multi sub MAIN(
    Str $infile,
    Bool :$list!,
    ) {
    my $doc = PDF::DOM.open($infile);
    my @fields = $doc.Root.AcroForm.fields
	if $doc.Root.?AcroForm;

    if +@fields {
	my %fields-hash;

	for @fields -> $field {
	    my $key = '???';
	    if $field.T && !(%fields-hash{ $field.T }:exists) {
		$key = $field.T
	    }
	    else {
		$key = $field.TU
		    if $field.TU && !(%fields-hash{ $field.TU }:exists);
	    }
	    %fields-hash{$key} = $field.V;
	}

	say "{.key}: {.value}"
	    for %fields-hash.pairs.sort;
    }
    else {
	warn "this PDF has no form fields";
    }
}
=begin pod

=head1 NAME

fillpdffields.p6 - Replace PDF form fields with specified values

=head1 SYNOPSIS

 fillpdffields.p6 [options] infile.pdf outfile.pdf field value [field value ...]

 Options:
   -b --background=val  specify a background color behind the filled text field
                        Options are: 'none', gray or 'r g b'.  Default: '1'
   -t --triggerclear    remove all of the form triggers after replacing values
   -V --version         print CAM::PDF version

Examples of C<--background> values are:

  --background=none
  --background=1        # white
  --background=0.5      # gray
  --background=0        # black
  --background="1 0 0"  # red

=head1 DESCRIPTION

Fill in the forms in the PDF with the specified values, identified by
their field names.  See F<listpdffields.pl> for a the names of the form
fields.

=head1 SEE ALSO

CAM::PDF (Perl 5)
PDF::DOM (Perl 6)

F<listpdffields.pl>

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
