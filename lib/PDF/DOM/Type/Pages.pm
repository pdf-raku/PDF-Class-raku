use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;
use PDF::DOM::Type::Page;
use PDF::Object::Inheritance;
use PDF::DOM::Resources;
use PDF::DOM::PageSizes;

# /Type /Pages - a node in the page tree

class PDF::DOM::Type::Pages
    is PDF::Object::Dict
    does PDF::DOM::Type
    does PDF::Object::Inheritance
    does PDF::DOM::PageSizes
    does PDF::DOM::Resources {

    use PDF::Object::Tie;

    # see [PDF 1.7 TABLE 3.26 Required entries in a page tree node
    has Hash $!Parent is entry;            #| (Required except in root node; must be an indirect reference) The page tree node that is the immediate parent of this one.
    has Array $!Kids is entry(:required);  #| (Required) An array of indirect references to the immediate children of this node. The children may be page objects or other page tree nodes.
    has Int $!Count is entry(:required);   #| (Required) The number of leaf nodes (page objects) that are descendants of this node within the page tree.
    has Hash $!Resources is entry;

    #| add new last page
    method add-page( $page = PDF::DOM::Type::Page.new ) {
        my $sub-pages = self.Kids[*-1]
            if self.Kids;

        if $sub-pages && $sub-pages.can('add-page') {
            $sub-pages.add-page( $page )
        }
        else {
            self.Kids.push: $page;
        }

        $page<Parent> //= self;
        self<Count>++;

        $page
    }

    #| $.page(0) or $.page(-1) adds a new page
    multi method page(Int $page-num where $page-num == 0|-1
	--> PDF::DOM::Type::Page) {
        self.add-page;
    }

    #| terminal page node - no children
    multi method page(Int $page-num where { self.Count == + self.Kids && $_ <= + self.Kids}) {
        self.Kids[$page-num - 1];
    }

    #| traverse page tree
    multi method page(Int $page-num where { $page-num > 0 && $page-num <= self<Count> }) {
        my Int $page-count = 0;

        for self.Kids.keys {
            my $kid = self.Kids[$_];

            if $kid.can('page') {
                my Int $sub-pages = $kid<Count>;
                my Int $sub-page-num = $page-num - $page-count;

                return $kid.page( $sub-page-num )
                    if $sub-page-num > 0 && $sub-page-num <= $sub-pages;

                $page-count += $sub-pages
            }
            else {
                $page-count++;
                return $kid
                    if $page-count == $page-num;
            }
        }

        die "unable to locate page: $page-num";
    }

    #| delete page from page tree
    multi method delete-page(Int $page-num where { $page-num > 0 && $page-num <= self<Count>},
	--> PDF::DOM::Type::Page) {
        my $page-count = 0;

        for self.Kids.keys -> $i {
            my $kid = self.Kids[$i];

            if $kid.can('page') {
                my $sub-pages = $kid<Count>;
                my $sub-page-num = $page-num - $page-count;

                if $sub-page-num > 0 && $sub-page-num <= $sub-pages {
                    # found in descendant
                    self<Count>--;
                    return $kid.delete-page( $sub-page-num );
                }

                $page-count += $sub-pages
            }
            else {
                $page-count++;
                if $page-count == $page-num {
                    # found at leaf
                    self<Kids>.splice($i, 1);
                    self<Count>--;
                    return $kid
                }
            }
        }

        die "unable to locate page: $page-num";
    }

    method AT-POS($pos) is rw {
        self.page($pos + 1)
    }

    method cb-init {
	self<Type> = PDF::Object.compose( :name<Pages> );
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
            $kid.<Parent> //= self;
            $kid.cb-finish;
            $count += $kid.can('Count') ?? $kid.Count !! 1;
        }
        self<Count> = $count;
    }

}
