use v6;

use PDF::DAO::Dict;
use PDF::Content::Font;
use PDF::Zen::Type;

# /Type /Font - Describes a font

class PDF::Font
    is PDF::DAO::Dict
    does PDF::Content::Font
    does PDF::Zen::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    
    my subset Name-Font of PDF::DAO::Name where 'Font';
    has Name-Font $.Type is entry(:required);
    has PDF::DAO::Name $.Subtype is entry(:required);

    method font-obj {
        ## callsame() //= self.make-font-obj ; # not working
        callsame() // self.set-font-obj: self.make-font-obj;
    }

    method make-font-obj {
        # stub for other font types
        use Font::Metrics::courier;
        use PDF::Content::Util::Font :Encoded;
        use PDF::Content::Font::Enc::Type1;

        warn "don't know how to make font of type: {self.Type}";
        (Font::Metrics::courier but Encoded[PDF::Content::Font::Enc::Type1]).new;
    }
}

