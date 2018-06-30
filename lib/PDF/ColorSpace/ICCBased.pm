use v6;

use PDF::ColorSpace;

class PDF::ColorSpace::ICCBased
    is PDF::ColorSpace {

    use PDF::COS::Tie;
    use PDF::ICCProfile;

    # see [PDF 1.7 TABLE 4.16 Additional entries specific to an ICC profile stream dictionary]
    has PDF::ICCProfile $.dict is index(1);
    method N         is rw { self.dict.N }
    method Alternate is rw { self.dict.Alternate }
    method Range     is rw { self.dict.Range }
    method Metadata  is rw { self.dict.Metadata }

}
