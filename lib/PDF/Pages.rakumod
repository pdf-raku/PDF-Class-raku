#| /Type /Pages - a node in the page tree
unit class PDF::Pages;

use PDF::COS::Dict;
use PDF::Class::Type;
use PDF::Content::PageNode;
use PDF::Content::PageTree;

also is PDF::COS::Dict;
also does PDF::Class::Type;
also does PDF::Content::PageNode;
also does PDF::Content::PageTree;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Resources;

use ISO_32000::Table_29-Required_entries_in_a_page_tree_node;
also does ISO_32000::Table_29-Required_entries_in_a_page_tree_node;

use ISO_32000_2::Table_30-Required_entries_in_a_page_tree_node;
also does ISO_32000_2::Table_30-Required_entries_in_a_page_tree_node;

has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Pages';
has PDF::Pages $.Parent is entry(:indirect); # (Required except in root node; must be an indirect reference) The page tree node that is the immediate parent of this one.
has PDF::Content::PageNode @.Kids is entry(:required, :indirect);  # (Required) An array of indirect references to the immediate children of this node. The children may be page objects or other page tree nodes.
has UInt $.Count is entry(:required);   # (Required) The number of leaf nodes (page objects) that are descendants of this node within the page tree.
has PDF::Resources $.Resources is entry(:inherit);
has Int $.Rotate is entry(:inherit, :alias<rotate>) where { $_ %% 90 };     # (Optional; inheritable) The number of degrees by which the page should be rotated clockwise when displayed or printed
#| inheritable page properties
has Numeric @.MediaBox is entry(:inherit,:len(4));
has Numeric @.CropBox is entry(:inherit,:len(4));

method cb-init {
    self<Type> //= PDF::COS::Name.COERCE: 'Pages';
    unless (self<Kids>:exists) || (self<Count>:exists) {
        self<Kids> = [];
        self<Count> = 0;
    }
}

method cb-finish {
    my Int $count = 0;
    my Array $kids = self.Kids;
    for $kids.keys {
        my $kid = $kids[$_];
        $kid<Parent> = self.link;
        $kid.cb-finish;
        $count += $kid.can('Count') ?? $kid.Count !! 1;
    }
    self<Count> = $count;
}
