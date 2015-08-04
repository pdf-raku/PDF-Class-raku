use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /ExtGState

class PDF::DOM::Type::ExtGState
    is PDF::Object::Dict
    does PDF::DOM::Type {

    use PDF::Object::Tie;
    use PDF::Object::Name;

    # see [PDF .1.7 TABLE 4.8 Entries in a graphics state parameter dictionary]
    has Numeric $.LW is entry;             #| (Optional; PDF 1.3) The line width
    has Int $.LC is entry;                 #| (Optional; PDF 1.3) The line cap style
    has Int $.LJ is entry;                 #| (Optional; PDF 1.3) The line join style
    has Numeric $.ML is entry;             #| (Optional; PDF 1.3) The miter limit
    has Array $.D is entry;                #| (Optional; PDF 1.3) The line dash pattern, expressed as an array of the form [ dashArray dashPhase ], where dashArray is itself an array and dashPhase is an integer
    has PDF::Object::Name $.RI is entry;   #| (Optional; PDF 1.3) The name of the rendering intent
    has Bool $.OP is entry;                #| (Optional) A flag specifying whether to apply overprint
    has Bool $.op is entry;                #| (Optional; PDF 1.3) A flag specifying whether to apply overprint for painting operations other than stroking
    has Int $.OPM is entry;                #| (Optional; PDF 1.3) The overprint mode
    has Array $.Font is entry;             #| (Optional; PDF 1.3) An array of the form [ font size ], where font is an indirect reference to a font dictionary and size is a number expressed in text space units.
    has $.BG is entry;                     #| (Optional) The black-generation function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]
    has $.BG2 is entry;                    #| (Optional; PDF 1.3) Same as BG except that the value may also be the name Default, denoting the black-generation function that was in effect at the start of the page
    has $.UCR is entry;                    #| (Optional) The undercolor-removal function, which maps the interval [ 0.0 1.0 ] to the interval [ −1.0 1.0 ]
    has $.UCR2 is entry;                   #| (Optional; PDF 1.3) Same as UCR except that the value may also be the name Default, denoting the undercolor-removal function that was in effect at the start of the page.
    has $.TR is entry;                     #| (Optional) The transfer function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]
    has $.TR2 is entry;                    #| (Optional; PDF 1.3) Same as TR except that the value may also be the name Default, denoting the transfer function that was in effect at the start of the page.
    has $.HT is entry;                     #| (Optional) The halftone dictionary or stream (see Section 6.4, “Halftones”) or the name
    has Numeric $.FL is entry;             #| (Optional; PDF 1.3) The flatness tolerance
    has Numeric $.SM is entry;             #| (Optional; PDF 1.3) The smoothness tolerance
    has Bool $.SA is entry;                #| (Optional) A flag specifying whether to apply automatic stroke adjustment
    has $.BM is entry;                     #| (Optional; PDF 1.4) The current blend mode to be used in the transparent imaging model
    has $.SMask is entry;                  #| (Optional; PDF 1.4) The current soft mask, specifying the mask shape or mask opacity values to be used in the transparent imaging mode
    has Numeric $.CA is entry;             #| (Optional; PDF 1.4) The current stroking alpha constant, specifying the constant shape or constant opacity value to be used for stroking operations in the transparent imaging model
    has Numeric $.ca is entry;             #| (Optional; PDF 1.4) Same as CA, but for nonstroking operations
    has Bool $.AIS is entry;               #| (Optional; PDF 1.4) The alpha source flag (“alpha is shape”), specifying whether the current soft mask and alpha constant are to be interpreted as shape values (true) or opacity values (false).
    has Bool $.TK is entry;                #| (Optional; PDF 1.4) The text knockout flag, which determines the behavior of overlapping glyphs within a text object in the transparent imaging model

    # The graphics tranparency , with 0 being fully opaque and 1 being fully transparent.
    # This is a convenience method setting proper values for strokeaplha and fillalpha.
    method transparency(Numeric $alpha! where 0.0 ..1.0) {
	self.CA = $alpha;
	self.ca = $alpha;
    }

}
