[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::Thread
-------------------------

/Action Subtype - Thread

### has PDF::Filespec::FileRef $.F

[file specification] (Optional) The file containing the thread. If this entry is absent, the thread is in the current file.

### has PDF::Action::Thread::ThreadLike $.D

[dictionary, integer, or text string] (Required) The destination thread, specified in one of the following forms:

### has PDF::Action::Thread::BeadLike $.B

[dictionary or integer] (Optional) The bead in the destination thread, specified in one of the following forms:

