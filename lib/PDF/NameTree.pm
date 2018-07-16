use v6;

use PDF::COS::Tie::Hash;

role PDF::NameTree
    does PDF::COS::Tie::Hash {

    #| a lightweight tied hash to fetch objects from a Name Tree
    my class Names is Hash {
        has PDF::NameTree $.root is rw;
        has Bool %!fetched{Any};
        has Bool $realized;
        method !fetch($node, $key) {
            unless %!fetched{$node}++ {
                with $node.Names -> $names {
                    for 0, 2 ...^ +$names {
                        self.ASSIGN-KEY($names[$_], $names[$_ + 1]);
                    }
                }
                return self{$key}
                    if self{$key}:exists;
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
        method !fetch-all($node) {
            unless %!fetched{$node}++ {
                with $node.Names -> $names {
                    for 0, 2 ...^ +$names {
                        self.ASSIGN-KEY( $names[$_], $names[$_ + 1]);
                    }
                }
            }
            with $node.Kids -> $kids {
                for 0 ..^ +$kids {
                    self!fetch-all($_)
                        given $kids[$_];
                }
            }
        }
        method realize {
            self!fetch-all($!root)
                unless $!realized++;
        }
        method AT-KEY(Str $key) {
            if self{$key}:exists {
                nextsame();
            }
            else {
                callsame() = self!fetch($!root, $key);
            }
        }
        method keys   {self.realize; callsame}
        method values {self.realize; callsame}
        method pairs  {self.realize; callsame}
        method perl   {self.realize; callsame};
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
