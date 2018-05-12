use v6;

use PDF::Action;

#| /Action Subtype - GoTo

role PDF::Action::GoTo
    does PDF::Action {

    # see [PDF 1.7 TABLE 8.49 Additional entries specific to a go-to action]
    use PDF::COS::Tie;

    use PDF::Destination :DestSpec, :coerce-dest;
    has DestSpec $.D is entry(:required, :alias<destination>, :coerce(&coerce-dest));    #| (Required) The destination to jump to

}
