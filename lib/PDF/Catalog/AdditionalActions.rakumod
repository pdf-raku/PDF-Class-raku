use v6;

unit role PDF::Catalog::AdditionalActions;
use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;
# use ISO_32000::Table_197-Entries_in_the_document_catalogs_additional-actions_dictionary;
# also does ISO_32000::Table_197-Entries_in_the_document_catalogs_additional-actions_dictionary;

=begin pod
=head1 Description

Table 197 – Entries in the document catalog’s additional-actions dictionary

=head1 Methods (Entries)
=end pod

use PDF::COS::Tie;
use PDF::Action;

has PDF::Action $.WC is entry(:alias<will-close>); #= (Optional; PDF 1.4) A JavaScript action that is performed before closing a document.

has PDF::Action $.WS is entry(:alias<will-save>);  #= (Optional; PDF 1.4) A JavaScript action that is performed before saving a document.

has PDF::Action $.DS is entry(:alias<did-save>);   #= (Optional; PDF 1.4) A JavaScript action that is performed after saving a document.

has PDF::Action $.WP is entry(:alias<will-print>); #= (Optional; PDF 1.4) A JavaScript action that is performed before printing a document.

has PDF::Action $.DP is entry(:alias<did-print>);  #= (Optional; PDF 1.4) A JavaScript action that is performed after printing a document.


