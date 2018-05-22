use v6;

use PDF::ColorSpace;

class PDF::ColorSpace::ICCBased
    is PDF::ColorSpace {

    use PDF::COS::Name;
    use PDF::COS::Stream;
    use PDF::COS::Tie;

    # see [PDF 1.7 TABLE 4.16 Additional entries specific to an ICC profile stream dictionary]
    use PDF::ICCProfile;
    has PDF::ICCProfile $.dict is index(1);
    method N         is rw { self.dict.N }
    method Alternate is rw { self.dict.Alternate }
    method Range     is rw { self.dict.Range }
    method Metadata  is rw { self.dict.Metadata }

}
