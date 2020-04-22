use v6;
use PDF::COS::Tie::Hash;

unit role PDF::AdditionalActions
    does PDF::COS::Tie::Hash;
    # use ISO_32000::Table_194-Entries_in_an_annotations_additional-actions_dictionary;
    # also does  ISO_32000::Table_194-Entries_in_an_annotations_additional-actions_dictionary;
=begin pod

=head1 Description

Table 194 – Entries in an annotation’s additional-actions dictionary

=head1 Methods (Entries)

=end pod

use PDF::COS::Tie;
use PDF::Action;

has PDF::Action $.E is entry; # (Optional; PDF 1.2) An action that is performed when the cursor enters the annotation’s active area.

has PDF::Action $.X is entry; # (Optional; PDF 1.2) An action that is performed when the cursor exits the annotation’s active area.

has PDF::Action $.D is entry; # (Optional; PDF 1.2) An action that is performed when the mouse button is pressed inside the annotation’s active area.

has PDF::Action $.U is entry; # (Optional; PDF 1.2) An action that is performed when the mouse button is released inside the annotation’s active area.
# For backward compatibility, the A entry in an annotation dictionary, if present, takes precedence over this entry (see Table 168).

has PDF::Action $.Fo is entry; # (Optional; PDF 1.2; widget annotations only) An action that is performed when the annotation receives the input focus.

has PDF::Action $.Bl is entry; # (Optional; PDF 1.2; widget annotations only) (Uppercase B, lowercase L) An action that is performed when the annotation loses the input focus.

has PDF::Action $.PO is entry; # (Optional; PDF 1.5) An action that is performed when the page containing the annotation is opened.
# EXAMPLE 1 When the user navigates to it from the next or previous page or by means of a link annotation or outline item. The action is executed after the O action in the page’s additional-actions dictionary (see Table 195) and the OpenAction entry in the document Catalog (see Table 28), if such actions are present.

has PDF::Action $.PC is entry; # (Optional; PDF 1.5) An action that is performed when the page containing the annotation is closed.
# EXAMPLE 2 When the user navigates to the next or previous page, or follows a link annotation or outline item. The action is executed before the C action in the page’s additional-actions dictionary (see Table 195), if present.

has PDF::Action $.PV is entry; # (Optional; PDF 1.5) An action that is performed when the page containing the annotation becomes visible.

has PDF::Action $.PI is entry; # (Optional; PDF 1.5) An action that is performed when the page containing the annotation is no longer visible in the conforming reader’s user interface.

