#!/usr/bin/env raku
use v6;
use PDF::Class;

my %*SUB-MAIN-OPTS =
  :named-anywhere,    # allow named variables at any location 
;

#| list all fields and current values
multi sub MAIN(
    Str $infile,            #| input PDF
    Bool :list($)! where .so,
    Bool :$labels,          #| display labels, rather than keys
    Str  :$password = '',   #| password for the PDF/FDF, if encrypted
    UInt :$page,            #| selected page
    ) {
    my PDF::Class $pdf .= open($infile, :$password);
    my @fields = ($page ?? $pdf.page($page) !! $pdf).fields;

    if @fields {
        my $n = 0;
        for @fields {
            my $key = .TU if $labels;
            $key //= .T // '???';
            # value is commonly a text-string or name, but can
            # also be dictionary object (e.g. PDF::Signature)
            my $value = (.V // '').perl;
            say "{++$n}. $key: $value";
        }
    }
    else {
	warn "this {$pdf.type} file has no form fields";
    }
}

#| remove field formatting
multi sub MAIN(
    Str $infile,            #| input PDF
    Bool :reset($)! where .so,
    Bool :$reformat = True,
    Bool :$triggers = True,
    Str  :$save-as,
    Str  :$password = '',   #| password for the PDF/FDF, if encrypted
    ) {
    if !$reformat && $triggers {
        note "nothing to do";
    }
    else {
        my PDF::Class $pdf .= open($infile, :$password);
        with $pdf.Root.AcroForm {
            .NeedAppearances = True
                if $reformat;
            for .fields {
                .<AP>:delete if $reformat;
                .<AA>:delete unless $triggers;
            }
        }
        else {
	    warn "this {$pdf.type} has no form fields";
        }

        with $save-as {
            $pdf.save-as( $_ );
        }
        else {
            $pdf.update;
        }
    }
}

#| update PDF, setting specified fields from values
multi sub MAIN(
    Str $infile,
    UInt :$slice! is copy,
    Str  :$save-as,
    Str  :$password = '',
    UInt :$page,            #| selected page
    *@field-values) {
    $slice--; # 1 offset to 0 offset
    my PDF::Class $pdf .= open($infile, :$password);
    die "$infile has no fields defined"
	unless $pdf.Root.AcroForm;

    die "please provide a list of values --list to display fields"
	unless @field-values;

    my @fields = ($page ?? $pdf.page($page) !! $pdf).fields;
    my $n = +@fields;
    die  "too many field values"
        if $slice + @field-values > $n;

    for @field-values -> $v {
        my $fld = @fields[$slice++];
	$fld.V = $v;
    }

    with $save-as {
        $pdf.save-as( $_ );
    }
    else {
        $pdf.update;
    }
}

#| update PDF, setting specified fields from name-value pairs
multi sub MAIN(
    Str $infile,
    Bool :edit($)! where .so,
    Str  :$save-as,
    Bool :$labels,          #| display labels, rather than keys
    Str  :$password = '',
    UInt :$page,            #| selected page
    *%edits) {

    enum ( :Keys<T>, :Labels<TU> );
    my Str $key = $labels ?? Labels !! Keys;

    my PDF::Class $pdf .= open($infile, :$password);
    die "$infile has no fields defined"
	unless $pdf.Root.AcroForm;

    die "please provide field-values or --list to display fields"
	unless %edits;

    my %fields = ($page ?? $pdf.page($page) !! $pdf).fields-hash: :$key;

    for %edits.sort {
	if %fields{.key}:exists {
	    %fields{.key}.V = .value;
	}
	else {
	    warn "no such field: {.key}. Use --list to display fields";
	}
    }

    with $save-as {
        $pdf.save-as( $_ );
    }
    else {
        $pdf.update;
    }
}

=begin pod

=head1 NAME

pdf-fields.raku - Manipulate PDF fields

=head1 SYNOPSIS

 pdf-fields.raku --password=pass --page=n --save-as=out.pdf [options] in.pdf
 Options
   --list [--labels]                 % list fields and current values
   --edit [--labels] :key=value ...  % set fields from keys and values
   --slice[=n] value value ...       % set consecutive fields starting at n (first=1)
   --reset [-/reformat] [-triggers]  % reset fields. Defaults: remove format, keep triggers

 General Options:
   --page=n             select nth page
   --save-as=out.pdf    save to a file
   --password           provide user/owner password for an encrypted PDF

=head1 DESCRIPTION

List, edit or reset PDF form fields.

=head1 SEE ALSO

`fillpdffields.pl` from the Perl CAM::PDF CPAN module

=end pod
