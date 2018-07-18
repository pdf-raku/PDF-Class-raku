use v6;

use PDF::COS::Tie::Hash;

role PDF::NumberTree
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    has PDF::NumberTree @.Kids is entry(:indirect); #| (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Nums is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.
    has @.Nums is entry; #| Root and leaf nodes only; required in leaf nodes; present in the root node if and only if Kids is not present) An array of the form
                         #| [ key 1 value 1 key 2 value 2 ... key n value n ]
                         #| where each key i is an integer and the corresponding value i shall be the object associated with that key. The keys are sorted in numerical order
    my class Nums is Hash {
        has PDF::NumberTree $.root is rw;
        has Bool %!fetched{Any};
        has Bool $!realized;
        method !fetch($node, Int $key?) {
            unless %!fetched{$node}++ {
                with $node.Nums -> $nums {
                    for 0, 2 ...^ +$nums {
                        self.ASSIGN-KEY($nums[$_], $nums[$_ + 1]);
                    }
                }
                with $key {
                    return self{$_}
                        if self{$_}:exists;
                }
            }
            with $node.Kids -> $kids {
                for 0 ..^ +$kids {
                    given $kids[$_] {
                        if $key.defined {
                            my $limits = .Limits;
                            return self!fetch($_, $key)
                                if $limits[0] <= $key <= $limits[1];
                        }
                        else {
                            self!fetch($_);
                        }
                    }
                }
            }
        }
        method realize {
            self!fetch($!root)
                unless $!realized++;
            self;
        }
        method AT-KEY(Int(Cool) $key) {
            if $!realized || (self{$key}:exists) {
                nextsame();
            }
            else {
                self!fetch($!root, $key);
            }
        }
        method keys   {self.realize; callsame}
        method values {self.realize; callsame}
        method pairs  {self.realize; callsame}
        method perl   {self.realize; callsame};
    }

    method nums {
        given Nums[Int].new {
            .root = self;
            $_;
        }
    }
    has Numeric @.Limits is entry(:len(2)); #| (Shall be present in Intermediate and leaf nodes only) Shall be an array of two integers, that shall specify the (numerically) least and greatest keys included in the Nums array of a leaf node or in the Nums arrays of any leaf nodes that are descendants of an intermediate node.

    method cb-check {
        die "Number Tree has neither a /Kids or /Nums entry"
            unless (self<Kids>:exists) or (self<Nums>:exists);
    }
}
