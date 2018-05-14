use v6;

use PDF::COS::Tie::Hash;

role PDF::NameTree
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    has PDF::NameTree @.Kids is entry(:indirect); #| (Root and intermediate nodes only; required in intermediate nodes; present in the root node if and only if Names is not present) Shall be an array of indirect references to the immediate children of this node. The children may be intermediate or leaf nodes.
    has @.Names is entry; #| where each key i shall be a string and the corresponding value i shall be the object associated with that key. The keys shall be sorted in lexical order
    method names {
        with self<Names> -> $names {
            (1, 3 ... $names.elems).map: { $names[$_-1] => $names[$_] }
        }
    }
    has Str @.Limits is entry(:len(2)); #| Intermediate and leaf nodes only; required) Shall be an array of two strings, that shall specify the (lexically) least and greatest keys included in the Names array of a leaf node or in the Names arrays of any leaf nodes that are descendants of an intermediate node.
}
