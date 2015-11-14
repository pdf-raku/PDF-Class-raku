use v6;

use PDF::DOM;
use PDF::DAO::Type::Encrypt :PermissionsFlag;

#| list all fields and current values
multi sub MAIN(
    Str $infile,
    Bool :$list!,
    Str  :$password = '',
    ) {
    my $doc = PDF::DOM.open($infile, :$password);
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

#| update PDF, setting specified fields from name-value pairs
multi sub MAIN(
    Str $infile,
    Str  :$save-as,
    Bool :$update,
    Bool :$trigger-clear,
    Str  :$background,
    Str  :$password = '',
    Bool :$force = False,
    *@field-list) {

    die "please provide field-value pairs or --list to display fields"
	unless @field-list;

    die "last field not paired with a value: @field-list[*-1]"
	unless +@field-list %% 2;

##if ($opts{background} =~ m/\s/xms)
##{
##   # Separate r,g,b
##   $opts{background} = [split m/\s+/xms, $opts{background}];
##}

    my $doc = PDF::DOM.open($infile, :$password);
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

    if $save-as.defined {
        $doc.save-as( $save-as, :$force );
    }
    else {
        $doc.update;
    }
}

=begin pod

=head1 NAME

fillpdffields.p6 - Replace PDF form fields with specified values

=head1 SYNOPSIS

 fillpdffields.p6 [--save-as outfile.pdf --force] infile.pdf field value [field value ...]

 Options:
   --save-as=file.pdf  save to a new file
   --force             force save-as when digital signatures may be invalidated
   --triggerclear      remove all of the form triggers after replacing values

=head1 DESCRIPTION

Fill in the forms in the PDF with the specified values, identified by
their field names.  See C<fillpdffields.pl --list> lists form fields.

In some cases digital signatures may be invalidated when the document is saved
in full with the --save-as option. The --force option can be used to continue
with th save, in such circumstances.

=head1 SEE ALSO

CAM::PDF (Perl 5)
PDF::DOM (Perl 6)

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
