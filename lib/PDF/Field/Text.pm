use v6;

use PDF::Field;

role PDF::Field::Text
    does PDF::Field {

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Stream;
    use PDF::COS::TextString;

    use ISO_32000::Table_229-Additional_entry_specific_to_a_text_field;
    also does ISO_32000::Table_229-Additional_entry_specific_to_a_text_field;

    my subset TextOrStream of PDF::COS where PDF::COS::Stream | PDF::COS::TextString;
    multi sub coerce(Str $_ is rw, TextOrStream) {
	PDF::COS.coerce($_, PDF::COS::TextString)
    }
    multi sub coerce($_, TextOrStream) is default {
	fail "unable to coerce {.perl} to Text or a Stream";
    }
    has TextOrStream $.V is entry(:&coerce, :inherit, :alias<value>);
    has TextOrStream $.DV is entry(:&coerce, :inherit, :alias<default-value>);

    has UInt $.MaxLen is entry; # (Optional; inheritable) The maximum length of the field’s text, in characters.
}
