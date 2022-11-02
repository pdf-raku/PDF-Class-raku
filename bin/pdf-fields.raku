#!/usr/bin/env raku
use v6;
use PDF::Class;
use JSON::Fast;

my %*SUB-MAIN-OPTS =
  :named-anywhere,    # allow named variables at any location 
;

subset PosInt of Int where * > 0;

#| remove field formatting
multi sub MAIN(
    Str $infile,            #= input PDF
    Bool :reset($)! where .so,
    Bool :$reformat = True,
    Bool :$triggers = True,
    Str  :$save-as,
    Str  :$password = '',   #= password for the PDF/FDF, if encrypted
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
    Str    $infile,
    PosInt:D  :$slice!,
    Str    :$save-as,
    Str    :$password = '',
    UInt   :$page,            #| selected page
    Bool   :$reformat = True,
    Bool   :$triggers = True,
    *@field-values) {
    my UInt:D $i = $slice - 1; # 1 offset to 0 offset
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
        my $fld = @fields[$i++];
	$fld.V = $v;
        $fld<AP>:delete if $reformat;
        $fld<AA>:delete unless $triggers;
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
    Bool :fill($)! where .so,
    Str  :$save-as,
    Bool :$labels,          #| display labels, rather than keys
    Str  :$password = '',
    UInt :$page,            #| selected page
    Bool :$reformat = True,
    Bool :$triggers = True,
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
            my $fld = %fields{.key};
	    $fld.V = .value;
            $fld<AP>:delete if $reformat;
            $fld<AA>:delete unless $triggers;
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

#| list all fields and current values
multi sub MAIN(
    Str $infile,            #= input PDF
    Bool :list($),          #= default
    Bool :$json,            #= display as json
    Bool :$labels,          #= display labels, rather than keys
    Str  :$password = '',   #= password for the PDF/FDF, if encrypted
    UInt :$page,            #= selected page
    ) {
    my PDF::Class $pdf .= open($infile, :$password);
    my @fields = ($page ?? $pdf.page($page) !! $pdf).fields;
    my %json;

    if @fields {
        my $n = 0;
        for @fields {
            my $key = .TU if $labels;
            $key //= .T // '???';
            # value is commonly a text-string or name, but can
            # also be dictionary object (e.g. PDF::Signature)
            my $value = (.V // '');
            if $json {
                %json{$key} = $value;
            }
            else {
                say "{++$n}. $key: " ~ $value.raku;
            }
        }
        say to-json(%json, :sorted-keys) if $json;
    }
    else {
	warn "this {$pdf.type} file has no form fields";
    }
}

=begin pod

=head1 NAME

pdf-fields.raku - Manipulate PDF fields

=head1 SYNOPSIS

 pdf-fields.raku --password=pass --page=n --save-as=out.pdf [options] in.pdf
 Dispatch Options
   --list [--labels] [--json]          % list fields and current values
   --fill [--labels] -<key>=value ...  % set fields from keys and values
   --slice[=n] value value ...         % set consecutive fields starting at n (first=1)
   --reset [-/reformat] [-triggers]    % reset fields. Defaults: remove format, keep triggers

 General Options:
   --/reformat          disable reformatting
   --/triggers          remove triggers
   --page=n             select nth page
   --save-as=out.pdf    save to a file
   --password           provide user/owner password for an encrypted PDF

=head1 DESCRIPTION

List, edit or reset PDF form fields.

=head1 SEE ALSO

`fillpdffields.pl` from the Perl CAM::PDF CPAN module

=end pod
