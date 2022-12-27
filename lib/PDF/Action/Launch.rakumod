#| /Action Subtype - Launch
unit class PDF::Action::Launch;

use PDF::Action;
use PDF::COS::Dict;

also is PDF::COS::Dict;
also does PDF::Action;

# use ISO_32000::Table_203-Additional_entries_specific_to_a_launch_action;
# also does ISO_32000::Table_203-Additional_entries_specific_to_a_launch_action;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Filespec :FileRef, :&to-file;

has FileRef $.F is entry(:alias<file>, :coerce(&to-file)); # (Required if none of the entries Win, Mac, or Unix is present) The application that shall be launched or the document that shall be opened or printed. If this entry is absent and the conforming reader does not understand any of the alternative entries, it shall do nothing.
has Hash $.Win is entry; # (Optional) A dictionary containing parameters.
has $.Mac is entry; # (Optional) Mac OS–specific launch parameters; not yet defined.
has $.Unix is entry; # (Optional) UNIX-specific launch parameters; not yet defined.
has Bool $.NewWindow is entry; # (Optional; PDF 1.2) A flag specifying whether to open the destination document in a new window. If this flag is false, the destination document replaces the current document in the same window. If this entry is absent, the conforming reader should behave in accordance with its current preference. This entry shall be ignored if the file designated by the F entry is not a PDF document.

method cb-check {
    die "at least one of /F /Win /Mac or /Unix should be present"
        without $.F // $.Win // $.Mac // $.Unix;
}

