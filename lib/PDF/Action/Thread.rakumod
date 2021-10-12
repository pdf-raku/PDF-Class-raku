use v6;

use PDF::Action;
use PDF::COS::Dict;

#| /Action Subtype - Thread

class PDF::Action::Thread
    is PDF::COS::Dict
    does PDF::Action {

    # use ISO_32000::Table_205-Additional_entries_specific_to_a_thread_action;
    # also does ISO_32000::Table_205-Additional_entries_specific_to_a_thread_action;

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::Bead-Thread; # Declares PDF::Bead & PDF::Thread
    use PDF::Filespec :FileRef, :&to-file;
    use PDF::COS::TextString;

    has FileRef $.F is entry(:alias<file>, :coerce(&to-file));	# [file specification] (Optional) The file containing the thread. If this entry is absent, the thread is in the current file.
    my subset ThreadLike where PDF::Thread|PDF::COS::TextString|UInt;
    multi sub coerce(Hash $_, ThreadLike) { PDF::Thread.COERCE($_) }
    multi sub coerce(Str  $_, ThreadLike) { PDF::TextString.COERCE($_) }
    multi sub coerce($_, ThreadLike) is default { warn "unable to coerce {.raku} to a Thread" }
    has ThreadLike $.D is entry(:alias<thread>, :&coerce, :required);	# [dictionary, integer, or text string] (Required) The destination thread, specified in one of the following forms:
	# An indirect reference to a thread dictionary (see Link 12.4.3, “Articles” ). In this case, the thread is in the current file.
	# The index of the thread within the Threads array of its document’s Catalog (see Link 7.7.2, “Document Catalog” ). The first thread in the array has index 0.
	# The title of the thread as specified in its thread information dictionary (see Link Ta b l e 160 ). If two or more threads have the same title, the one appearing first in the document Catalog’s Threads array shall be used.
    my subset BeadLike where PDF::Bead|UInt;
    multi sub coerce-bead(Hash $_, BeadLike) { PDF::Bead.COERCE($_) }
    multi sub coerce-bead($_, BeadLike) is default { warn "unable to coerce {.raku} to a Bead" }
    has BeadLike $.B is entry(:alias<bead>, :coerce(&coerce-bead));	# [dictionary or integer] (Optional) The bead in the destination thread, specified in one of the following forms:
	# An indirect reference to a bead dictionary (see Link 12.4.3, “Articles” ). In this case, the thread is in the current file.
	# The index of the bead within its thread. The first bead in a thread has index 0.
}
