use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;
use PDF::Doc::Type::Page;
use PDF::Graphics::Paged;
use PDF::Graphics::Resourced;

# /Type /Pages - a node in the page tree

class PDF::Doc::Type::Pages
    is PDF::DAO::Dict
    does PDF::Doc::Type
    does PDF::Graphics::Paged
    does PDF::Graphics::Resourced {

    use PDF::DAO::Tie;
    use PDF::DAO;

    # see [PDF 1.7 TABLE 3.26 Required entries in a page tree node
    has Hash $.Parent is entry(:indirect); #| (Required except in root node; must be an indirect reference) The page tree node that is the immediate parent of this one.
    my subset PageNode of PDF::DAO::Dict where PDF::Doc::Type::Page | PDF::Doc::Type::Pages;
    has PageNode @.Kids is entry(:required, :indirect);  #| (Required) An array of indirect references to the immediate children of this node. The children may be page objects or other page tree nodes.
    has UInt $.Count is entry(:required);   #| (Required) The number of leaf nodes (page objects) that are descendants of this node within the page tree.
    use PDF::Doc::Type::Resources;
    has PDF::Doc::Type::Resources $.Resources is entry(:inherit);

    #| inheritable page properties
    has Numeric @.MediaBox is entry(:inherit,:len(4));
    has Numeric @.CropBox is entry(:inherit,:len(4));

    #| add new last page
    method add-page( PDF::Doc::Type::Page $page? is copy ) {
        my $sub-pages = self.Kids[*-1]
            if self.Kids;

	if $page {
	    unless $page<Resources>:exists {
		# import resources, if inherited and outside our heirarchy
		my $resources = $page.Resources;
		$page<Resources> = $resources.clone
		    if $resources && $resources !=== self.Resources;
	    }
	}
	else {
	    $page = PDF::DAO.coerce: { :Type( :name<Page> ) };
	}

        if $sub-pages && $sub-pages.can('add-page') {
            $sub-pages.add-page( $page )
        }
        else {
            self.Kids.push: $page;
	    $page<Parent> = self.link;
        }

        self<Count>++;

        $page
    }

    #| append page subtree
    method add-pages( PDF::Doc::Type::Pages $pages ) {
	self<Count> += $pages<Count>;
	self<Kids>.push: $pages;
	$pages<Parent> = self;
        $pages;
    }

    #| $.page(0) or $.page(-1) adds a new page
    multi method page(Int $page-num where $page-num == 0|-1
	--> PDF::Doc::Type::Page) {
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
	--> PDF::Doc::Type::Page) {
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

    # allow array indexing of pages $pages[9] :== $.pages.page(10);
    method AT-POS($pos) is rw {
        self.page($pos + 1)
    }

    method cb-init {
	self<Type> = PDF::DAO.coerce( :name<Pages> );
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

}
