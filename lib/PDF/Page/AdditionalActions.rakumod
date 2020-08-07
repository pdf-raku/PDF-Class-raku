use v6;
use PDF::COS::Tie::Hash;

unit role PDF::Page::AdditionalActions
    does PDF::COS::Tie::Hash;
    # use ISO_32000::Table_195-Entries_in_a_page_objects_additional-actions_dictionary;
    # also does ISO_32000::Table_195-Entries_in_a_page_objects_additional-actions_dictionary;

use PDF::COS::Tie;
use PDF::Action;

=begin pod

=head1 Description

Table 195 – Entries in a page object’s additional-actions dictionary

=head1 Methods (Entries)
=end pod

#| (Optional; PDF 1.2) An action that is performed when the page is opened (for example, when the user navigates to it from the next or previous page or by means of a link annotation or outline item). This action is independent of any that may be defined by the OpenAction entry in the document Catalog (see 7.7.2, “Document Catalog”) and is executed after such an action.
has PDF::Action $.O is entry;

#| (Optional; PDF 1.2) An action that is performed when the page is closed (for example, when the user navigates to the next or previous page or follows a link annotation or an outline item). This action applies to the page being closed and is executed before any other page is opened.
has PDF::Action $.C is entry;
