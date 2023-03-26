use v6;

role PDF::NameTree {
    use PDF::COS::Tie::Hash;
    also does PDF::COS::Tie::Hash;

    # use ISO_32000::Table_36-Entries_in_a_name_tree_node_dictionary;
    # also does ISO_32000::Table_36-Entries_in_a_name_tree_node_dictionary;

    use PDF::COS;
    use PDF::COS::Tie;

    my class NameTree is export(:NameTree) {
        has %!values;
        has PDF::NameTree $.root;
        has Bool %!fetched{Any};
        has Bool $!realized;
        has Bool $.updated is rw;
        has Lock:D $!lock .= new;

        method !fetch($node, Str $key?) {
            with $node.Names -> $kv {
                # leaf node
                $!lock.protect: {
                    unless %!fetched{$node}++ {
                        for 0, 2 ...^ +$kv {
                            my $val = $kv[$_ + 1];
                          .($val, $!root.of)
                               with $!root.coercer;
                             %!values{ $kv[$_] } = $val;
                        }
                    }
                }
            }
            else {
                # branch node
                given $node.Kids -> $kids {
                    for ^+$kids {
                        given $kids[$_] -> $kid {
                            with $key {
                                my @limits[2] = $kid.Limits;
                                return self!fetch($kid, $_)
                                    if @limits[0] le $_ le @limits[1];
                            }
                            else {
                                self!fetch($kid);
                            }
                        }
                    }
                }
            }
        }

        method Hash handles <keys values pairs raku> {
            self!fetch($!root)
                unless $!lock.protect: { $!realized++ };
            %!values;
        }

        method AT-KEY(Str() $key) is rw {
            Proxy.new(
                FETCH => {
                    self!fetch($!root, $key)
                        unless $!lock.protect: { $!realized || (%!values{$key}:exists); }
                    %!values{$key};
                },
                STORE => -> $, $val {
                    self.ASSIGN-KEY($key, $val)
                }
            )
        }

        method ASSIGN-KEY(Str() $key, $val is copy) {
            .($val, $!root.of)
                with $!root.coercer;
            $!lock.protect: {
                $!updated = True;
                self.Hash{$key} = $val;
            }
        }

        method DELETE-KEY(Str() $key) {
            $!lock.protect: {
                $!updated = True;
                self.Hash{$key}:delete;
            }
        }

    }

    my Lock $lock .= new;
    has NameTree $!name-tree;
    method name-tree(PDF::NameTree:D $root:) {
        $lock.protect: { $!name-tree //= NameTree.new: :$root }
    }

    has PDF::NameTree @.Kids is entry(:indirect); # (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Names is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.

    has @.Names is entry; # where each key i shall be a string and the corresponding value i shall be the object associated with that key. The keys shall be sorted in lexical order

    has Str @.Limits is entry(:len(2)); # Intermediate and leaf nodes only; required) Shall be an array of two strings, that shall specify the (lexically) least and greatest keys included in the Names array of a leaf node or in the Names arrays of any leaf nodes that are descendants of an intermediate node.

    method cb-check {
        die "Name Tree has neither a /Kids or /Names entry"
            unless (self<Kids>:exists) or (self<Names>:exists);
        # realize it to check for errors.
        self.name-tree.Hash;
    }

    method cb-finish {
        with $!name-tree {
            if .updated {
                self<Kids>:delete;
                my @names;
                @names.append: .key, .value
                    for .Hash.pairs.sort;
                self<Names> = @names;
                .updated = False;
            }
        }
    }

    method coercer {Mu}
}

role PDF::NameTree[
    $type,
    :&coerce = sub ($_ is rw, $t) {
        $_ = $t.COERCE($_);
    },
] does PDF::NameTree {
    method of {$type}
    method coercer { &coerce; }
}

