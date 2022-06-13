use v6;

use PDF::COS::Dict;
use PDF::Action;

#| /Action Subtype - GoToR
class PDF::Action::GoToR
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_200-Additional_entries_specific_to_a_remote_go-to_action;
    # also does ISO_32000::Table_200-Additional_entries_specific_to_a_remote_go-to_action;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Destination :DestRef, :RemoteDestRef, :DestinationLike, :&coerce-dest;
    use PDF::Filespec :FileRef, :FileRefLike, :&to-file;
    use PDF::Page;

    has FileRef $.F is entry(:alias<file>, :required, :coerce(&to-file)); # (Required) The file in which the destination shall be located.
    has RemoteDestRef $.D is entry(:required, :alias<destination>, :coerce(&coerce-dest)); # (Required) The destination to jump to. If the value is an array defining an explicit destination, its first element shall be a page number within the remote document rather than an indirect reference to a page object in the current document. The first page shall be numbered 0.
    has Bool $.NewWindow is entry; # (Optional; PDF 1.2) A flag specifying whether to open the destination document in a new window. If this flag is false, the destination document replaces the current document in the same window. If this entry is absent, the conforming reader should behave in accordance with its preference.
    method construct(DestinationLike:D :$destination!, FileRefLike:D :$file!) {
        my RemoteDestRef:D $D = coerce-dest($destination, DestRef);
        my FileRef:D $F = to-file($file);
        my PDF::COS::Name() $Type = 'Action';
        my PDF::COS::Name() $S = 'GoToR';
        self.COERCE: %( :$Type, :$S, :$F, :$D );
    }
}
