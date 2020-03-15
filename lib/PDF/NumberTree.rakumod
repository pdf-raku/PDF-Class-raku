use v6;

use PDF::COS::Tie::Hash;

role PDF::NumberTree
    does PDF::COS::Tie::Hash {

    use PDF::COS;
    use PDF::COS::Tie;
    use Method::Also;

    # use ISO_32000::Table_37-Entries_in_a_number_tree_node_dictionary;
    # also does ISO_32000::Table_37-Entries_in_a_number_tree_node_dictionary;

    has PDF::NumberTree @.Kids is entry(:indirect); # (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Nums is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.
    has @.Nums is entry; # Root and leaf nodes only; required in leaf nodes; present in the root node if and only if Kids is not present) An array of the form
                         # [ key 1 value 1 key 2 value 2 ... key n value n ]
                         # where each key i is an integer and the corresponding value i shall be the object associated with that key. The keys are sorted in numerical order
    my class NumberTree is export(:NumberTree) {
        has %!values{Int};
        has PDF::NumberTree $.root;
        has Bool %!fetched{Any};
        has Bool $!realized;
        has Bool $.updated is rw;
        has Int  $.max-key is built;

        method max-key {
            $!max-key //= max(self.Hash.keys.max, -1); 
        }

        method !fetch($node, Int $key?) {
            with $node.Nums -> $kv {
                # leaf node
                unless %!fetched{$node}++ {
                    for 0, 2 ...^ +$kv {
                       my $val = $kv[$_ + 1];
                       .($val, $!root.of)
                           with $!root.coercer;
                       %!values{$kv[$_] + 0} = $val;
                    }
                }
            }
            else {
                # branch node
                given $node.Kids -> $kids {
                    for 0 ..^ +$kids {
                        given $kids[$_] -> $kid {
                            with $key {
                                my @limits[2] = $kid.Limits;
                                return self!fetch($kid, $_)
                                    if @limits[0] <= $_ <= @limits[1];
                            }
                            else {
                                self!fetch($kid);
                            }
                        }
                    }
                }
           }
        }

        method Hash handles <keys values pairs perl> {
            self!fetch($!root)
                unless $!realized++;
            %!values;
        }

        method AT-KEY(Int() $key) is also<AT-POS> {
            self!fetch($!root, $key)
                unless $!realized || (%!values{$key}:exists);
            %!values{$key};
        }

        method ASSIGN-KEY(Int() $key, $val is copy) is also<ASSIGN-POS> {
            .($val, $!root.of)
                with $!root.coercer;
            with $!max-key {
                $_ = $key if $key > $_;
            }
            $!updated = True;
            self.Hash{$key} = $val;
        }

        method DELETE-KEY(Int() $key) is also<DELETE-POS> {
            with $!max-key {
                $_ = Nil if $key == $_;
            }
            $!updated = True;
            self.Hash{$key}:delete;
        }
    }

    has NumberTree $!number-tree;
    method number-tree {
        $!number-tree //= NumberTree.new: :root(self);
    }

    has Numeric @.Limits is entry(:len(2)); # (Shall be present in Intermediate and leaf nodes only) Shall be an array of two integers, that shall specify the (numerically) least and greatest keys included in the Nums array of a leaf node or in the Nums arrays of any leaf nodes that are descendants of an intermediate node.

    method cb-check {
        die "Number Tree has neither a /Kids or /Nums entry"
            unless (self<Kids>:exists) or (self<Nums>:exists);
        # realize it to check for errors.
        self.number-tree.Hash;
    }

    method cb-finish {
        with $!number-tree {
            if .updated {
                self<Kids>:delete;
                my @nums;
                @nums.append: .key, .value
                    for .Hash.pairs.sort;
                self<Nums> = @nums;
                .updated = False;
            }
        }
    }

    method coercer {Mu}
}

role PDF::NumberTree[
    $type,
    :&coerce = sub ($_ is rw, $t) {
        PDF::COS.coerce($_, $t);
    },
] does PDF::NumberTree {
    method of {$type}
    method coercer { &coerce; }
}
