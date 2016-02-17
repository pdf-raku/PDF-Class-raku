use v6;

use PDF::Struct::Action;

#| /Action Type - GoTo

role PDF::Struct::Action::GoTo
    does PDF::Struct::Action {

    # see [PDF 1.7 TABLE 8.49 Additional entries specific to a go-to action]
    use PDF::DAO::Tie;

    has $.D is entry(:required);    #| (Required) The destination to jump to (see Section 8.2.1, “Destinations”).

}
