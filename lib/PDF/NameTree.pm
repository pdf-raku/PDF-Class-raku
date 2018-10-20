use v6;

use PDF::COS::Tie::Hash;

role PDF::NameTree
    does PDF::COS::Tie::Hash {

    use ISO_32000::Name_tree_node;
    also does ISO_32000::Name_tree_node;

    use PDF::COS;
    #| a lightweight tied hash to fetch objects from a Name Tree
    use PDF::COS::Tie;

    my class NameTree is export(:NameTree) {
        has %!names;
        has PDF::NameTree $.root;
        has Bool %!fetched{Any};
        has Bool $!realized;
        method !fetch($node, Str $key?) {
            with $node.Names -> $kv {
                unless %!fetched{$node}++ {
                    for 0, 2 ...^ +$kv {
                        my $val = $kv[$_ + 1];
                        $!root.coerce-node($val)
                            if $!root.coerce-nodes;
                        %!names{ $kv[$_] } = $val;
                    }
                }
            }
            else {
                given $node.Kids -> $kids {
                    for 0 ..^ +$kids {
                        given $kids[$_] {
                            if $key.defined {
                                my @limits[2] = .Limits;
                                return self!fetch($_, $key)
                                    if @limits[0] le $key le @limits[1];
                            }
                            else {
                                self!fetch($_);
                            }
                        }
                    }
                }
            }
        }

        method Hash handles <keys values pairs perl> {
            self!fetch($!root)
                unless $!realized++;
            %!names;
        }
        method AT-KEY(Str() $key) {
            self!fetch($!root, $key)
               unless $!realized || (%!names{$key}:exists);
            %!names{$key};
        }
    }

    method name-tree {
        NameTree.new: :root(self);
    }

    has PDF::NameTree @.Kids is entry(:indirect); #| (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Names is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.
    has @.Names is entry; #| where each key i shall be a string and the corresponding value i shall be the object associated with that key. The keys shall be sorted in lexical order
    has Str @.Limits is entry(:len(2)); #| Intermediate and leaf nodes only; required) Shall be an array of two strings, that shall specify the (lexically) least and greatest keys included in the Names array of a leaf node or in the Names arrays of any leaf nodes that are descendants of an intermediate node.
    method coerce-nodes {False}
}

role PDF::NameTree[
    $type,
    :&coerce = sub ($_ is rw, $t) {
        PDF::COS.coerce($_, $t);
    },
] does PDF::NameTree {
    method of {$type}
    method coerce-nodes {True}
    method coerce-node($node is rw) {
        &coerce($node, $type);
    }
}

