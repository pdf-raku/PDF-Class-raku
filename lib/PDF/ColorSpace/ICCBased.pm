use v6;

use PDF::ColorSpace;

class PDF::ColorSpace::ICCBased
    is PDF::ColorSpace {

    use PDF::COS::Tie;
    use PDF::ICCProfile;

    # see [PDF 1.7 TABLE 4.16 Additional entries specific to an ICC profile stream dictionary]
    has PDF::ICCProfile $.dict is index(1);
    method props is rw handles <N Alternate Range Metadata> { $.dict }
}
