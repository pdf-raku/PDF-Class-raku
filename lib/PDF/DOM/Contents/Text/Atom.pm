use v6;

#| smallest 'atomic', ie indivisable, unit of text
#| likely to be a word. Could be smaller when kerning.
class PDF::DOM::Contents::Text::Atom {
    has Numeric $.width;
    has Numeric $.space is rw = 0;       #| kerning (-), or word spacing (+) adjustment before next atom
    has Bool $.sticky is rw = False;     #| don't allow preceeding line breaks
    has Bool $.elastic is rw = False;    #| stretchable, e.g. when justifying text
    has Str $.content;
    has Str $.encoded is rw;

    submethod BUILD( :$!width!, :$!content!, :$!space = 0, :$!sticky = False, :$!elastic = False ) {
    }

    method split {
        die "can't split atoms";
    }
}
