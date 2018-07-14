use v6;

use PDF::COS::Tie::Hash;

role PDF::NameTree
    does PDF::COS::Tie::Hash {

    #| a lightweight tied hash to fetch objects from a Name Tree
    my class Names is Hash {
        has PDF::NameTree $.root is rw;
        method !fetch($node, $key) {
            with $node.Names -> $names {
                my $l = 0;
                my $r = +$names div 2 - 1;
                loop {
                    # binary search of ordered name-key pairs
                    last if $l > $r;

                    my $m = ($l + $r) div 2;
                    my $i = 2 * $m;
                    given $key cmp $names[$i] {
                        when Same { return $names[$i + 1]; }
                        when More { $l = $m + 1 }
                        when Less { $r = $m - 1 }
                    }
                }
            }
            with $node.Kids -> $kids {
                for 0 ..^ +$kids {
                    given $kids[$_] {
                        my $limits = .Limits;
                        return self!fetch($_, $key)
                            if $limits[0] le $key le $limits[1];
                    }
                }
            }
        }
        method AT-KEY(Str $key) {
            if self{$key}:exists {
                nextsame();
            }
            else {
                callsame() = self!fetch($!root, $key);
            }
        }
        method keys { ... }
    }

    method names {
        given Names.new {
            .root = self;
            $_;
        }
    }

    use PDF::COS::Tie;
    has PDF::NameTree @.Kids is entry(:indirect); #| (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Names is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.
    has @.Names is entry; #| where each key i shall be a string and the corresponding value i shall be the object associated with that key. The keys shall be sorted in lexical order
    has Str @.Limits is entry(:len(2)); #| Intermediate and leaf nodes only; required) Shall be an array of two strings, that shall specify the (lexically) least and greatest keys included in the Names array of a leaf node or in the Names arrays of any leaf nodes that are descendants of an intermediate node.
}
