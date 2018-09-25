use v6;

use PDF::ColorSpace;

class PDF::ColorSpace::CalGray
    is PDF::ColorSpace {

    use PDF::COS::Tie;
    use PDF::COS::Tie::Hash;

    # see [PDF 1.7 TABLE 4.13 Entries in a CalGray color space dictionary]
    role CalGrayDict
	does PDF::COS::Tie::Hash {
	has Numeric @.WhitePoint is entry(:len(3), :required); #| (Required) An array of three numbers [ XW YW ZW ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse white point. The numbers XW and ZW must be positive, and YW must be equal to 1.0.
	has Numeric @.BlackPoint is entry(:len(3), :default[0.0, 0.0, 0.0]);            #| (Optional) An array of three numbers [ XB YB ZB ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse black point. All three of these numbers must be non-negative. Default value: [ 0.0 0.0 0.0 ].
	has Numeric $.Gamma is entry(:default(1));                          #| (Optional) A number G defining the gamma for the gray (A) component. G must be positive and is generally greater than or equal to 1. Default value: 1.
    }

    has CalGrayDict $.dict is index(1);
    method props is rw handles <WhitePoint BlackPoint Gamma> { $.dict; }
}
