use v6;

use PDF::DAO::Dict;
use PDF::Doc::Type;

# /Type /ExtGState

class PDF::Doc::Type::ExtGState
    is PDF::DAO::Dict
    does PDF::Doc::Type {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    sub dual-entries(PDF::Doc::Type::ExtGState $obj, Str $entry, Str $entry2) is rw {
	Proxy.new( 
	    FETCH => method {
		my $val   = $obj{$entry};
		my $val2  = $obj{$entry2};
		$val.defined && !$val2.defined
		    ?? $val
		    !! $val2;
	    },
	    STORE => method ($val is copy) {
		$obj{$entry}:delete;
		$obj{$entry2} = $val;
	    });
    }

    # see [PDF .1.7 TABLE 4.8 Entries in a graphics state parameter dictionary]
    my subset Name-ExtGState of PDF::DAO::Name where 'ExtGState';
    has Name-ExtGState $.Type is entry;
    has Numeric $.LW is entry(:alias<line-width>);                  #| (Optional; PDF 1.3) The line width
    has UInt $.LC is entry(:alias<line-cap>);                       #| (Optional; PDF 1.3) The line cap style
    has UInt $.LJ is entry(:alias<line-join-style>);                #| (Optional; PDF 1.3) The line join style
    has Numeric $.ML is entry(:alias<miter-limit>);                 #| (Optional; PDF 1.3) The miter limit
    has UInt @.D is entry(:alias<dash-pattern>);                    #| (Optional; PDF 1.3) The line dash pattern, expressed as an array of the form [ dashArray dashPhase ], where dashArray is itself an array and dashPhase is an integer
    has PDF::DAO::Name $.RI is entry(:alias<rendering-intent>);  #| (Optional; PDF 1.3) The name of the rendering intent
    has Bool $.OP is entry(:alias<overprint-paint>);                #| (Optional) A flag specifying whether to apply overprint
    has Bool $.op is entry(:alias<overprint-stroke>);               #| (Optional; PDF 1.3) A flag specifying whether to apply overprint for painting operations other than stroking
    has Int $.OPM is entry(:alias<overprint-mode>);                 #| (Optional; PDF 1.3) The overprint mode
    has Array @.Font is entry(:alias<fonts>,:len(2));               #| (Optional; PDF 1.3) An array of the form [ font size ], where font is an indirect reference to a font dictionary and size is a number expressed in text space units.

    has $.BG is entry;                     #| (Optional) The black-generation function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]
    has $.BG2 is entry;                    #| (Optional; PDF 1.3) Same as BG except that the value may also be the name Default, denoting the black-generation function that was in effect at the start of the page
    #| If both BG and BG2 are present in the same graphics state parameter dictionary, BG2 takes precedence.
    method black-generation is rw { dual-entries(self, 'BG', 'BG2') }

    has $.UCR is entry;                    #| (Optional) The undercolor-removal function, which maps the interval [ 0.0 1.0 ] to the interval [ −1.0 1.0 ]
    has $.UCR2 is entry;                   #| (Optional; PDF 1.3) Same as UCR except that the value may also be the name Default, denoting the undercolor-removal function that was in effect at the start of the page.
    method undercover-removal-function is rw { dual-entries(self, 'BG', 'BG2') }


    has $.TR is entry;                     #| (Optional) The transfer function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]
    has $.TR2 is entry;                    #| (Optional; PDF 1.3) Same as TR except that the value may also be the name Default, denoting the transfer function that was in effect at the start of the page.
    method transfer-function is rw { dual-entries(self, 'TR', 'TR2') }

    has $.HT is entry;                     #| (Optional) The halftone dictionary or stream (see Section 6.4, “Halftones”) or the name
    has Numeric $.FL is entry(:alias<flatness-tolerance>);   #| (Optional; PDF 1.3) The flatness tolerance
    has Numeric $.SM is entry(:alias<smoothness-tolarence>); #| (Optional; PDF 1.3) The smoothness tolerance
    has Bool $.SA is entry(:alias<auto-stroke-adjust>);      #| (Optional) A flag specifying whether to apply automatic stroke adjustment
    has $.BM is entry(:alias<blend-mode>);                   #| (Optional; PDF 1.4) The current blend mode to be used in the transparent imaging model
    has $.SMask is entry(:alias<soft-mask>);                 #| (Optional; PDF 1.4) The current soft mask, specifying the mask shape or mask opacity values to be used in the transparent imaging mode
    subset Alpha of Numeric where 0.0 .. 1.0;
    has Alpha $.CA is entry(:alias<stroke-alpha>);         #| (Optional; PDF 1.4) The current stroking alpha constant, specifying the constant shape or constant opacity value to be used for stroking operations in the transparent imaging model
    has Alpha $.ca is entry(:alias<fill-alpha>);           #| (Optional; PDF 1.4) Same as CA, but for nonstroking operations
    has Bool $.AIS is entry(:alias<alpha-source>);           #| (Optional; PDF 1.4) The alpha source flag (“alpha is shape”), specifying whether the current soft mask and alpha constant are to be interpreted as shape values (true) or opacity values (false).
    has Bool $.TK is entry(:alias<text-knockout>);           #| (Optional; PDF 1.4) The text knockout flag, which determines the behavior of overlapping glyphs within a text object in the transparent imaging model

    # The graphics transparency , with 0 being fully opaque and 1 being fully transparent.
    # This is a convenience method setting proper values for strokeaplha and fillalpha.
    method transparency is rw {
	my $obj = self;
	Proxy.new( 
	    FETCH => method {
		my $fill-alpha = $obj.fill-alpha;
		$fill-alpha eqv $obj.stroke-alpha
		    ?? $fill-alpha
		    !! Mu
	    },
	    STORE => method (Alpha $val is copy) {
		$obj.fill-alpha = $obj.stroke-alpha = $val;
	    });
    }

}
