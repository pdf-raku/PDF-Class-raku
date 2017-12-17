use v6;

use PDF::DAO::Dict;
use PDF::Content::Font;
use PDF::Class::Type;

# /Type /Font - Describes a font

class PDF::Font
    is PDF::DAO::Dict
    does PDF::Content::Font
    does PDF::Class::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    my subset Name-Font of PDF::DAO::Name where 'Font';
    has Name-Font $.Type is entry(:required);
    has PDF::DAO::Name $.Subtype is entry(:required);

    method font-obj is rw {
        ## callsame() //= self.make-font-obj ; # not working
        callsame() // self.set-font-obj: self.make-font-obj;
    }

    method make-font-obj {
        # stub for other font types
        use Font::Metrics::courier;
        use PDF::Content::Font::CoreFont;
        use PDF::Content::Font::Enc::Type1;

        warn "don't know how to make font of type: {self.Type}";
        my $metrics = Font::Metrics::courier;
        my $encoder = PDF::Content::Font::Enc::Type1.new;
        PDF::Content::Font::CoreFont.new: :$metrics, :$encoder;
        
    }
}

