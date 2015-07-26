use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Encoding - a node in the page tree
# see [PDF 1.7 Section 5.5.5 Character Encoding]
class PDF::DOM::Type::Encoding
    is PDF::Object::Dict
    does PDF::DOM::Type {

    # see [PDF 1.7 TABLE 5.11 Entries in an encoding dictionary]
    use PDF::Object::Tie;
    use PDF::Object::Name;
    has PDF::Object::Name $!BaseEncoding is entry; #| (Optional) The base encoding—that is, the encoding from which the Differencesentry (if present) describes differences—
    has Array $!Differences is entry;              #| (Optional; not recommended with TrueType fonts) An array describing the differences from the encoding specified by BaseEncoding or, if BaseEncoding is absent, from an implicit base encoding.

}
