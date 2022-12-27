unit class PDF::ColorSpace::CalGray;

use PDF::ColorSpace;
also is PDF::ColorSpace;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

role CalGrayDict
    does PDF::COS::Tie::Hash {

    # use ISO_32000::Table_63-Entries_in_a_CalGray_Colour_Space_Dictionary;
    # also does ISO_32000::Table_63-Entries_in_a_CalGray_Colour_Space_Dictionary;

    has Numeric @.WhitePoint is entry(:len(3), :required); # (Required) An array of three numbers [ XW YW ZW ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse white point. The numbers XW and ZW must be positive, and YW must be equal to 1.0.

    has Numeric @.BlackPoint is entry(:len(3), :default[0.0, 0.0, 0.0]);            # (Optional) An array of three numbers [ XB YB ZB ] specifying the tristimulus value, in the CIE 1931 XYZ space, of the diffuse black point. All three of these numbers must be non-negative. Default value: [ 0.0 0.0 0.0 ].

    has Numeric $.Gamma is entry(:default(1));                          # (Optional) A number G defining the gamma for the gray (A) component. G must be positive and is generally greater than or equal to 1. Default value: 1.
}

has CalGrayDict $.dict is index(1);
method props is rw handles <WhitePoint BlackPoint Gamma> { $.dict; }
