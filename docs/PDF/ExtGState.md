[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /ExtGState

### has Numeric $.LW

(Optional; PDF 1.3) The line width

### has UInt $.LC

(Optional; PDF 1.3) The line cap style

### has UInt $.LJ

(Optional; PDF 1.3) The line join style

### has Numeric $.ML

(Optional; PDF 1.3) The miter limit

### has Positional[UInt] @.D

(Optional; PDF 1.3) The line dash pattern, expressed as an array of the form [ dashArray dashPhase ], where dashArray is itself an array and dashPhase is an integer

### has PDF::COS::Name $.RI

(Optional; PDF 1.3) The name of the rendering intent

### has Bool $.OP

(Optional) A flag specifying whether to apply overprint

### has Bool $.op

(Optional; PDF 1.3) A flag specifying whether to apply overprint for painting operations other than stroking

### has Int $.OPM

(Optional; PDF 1.3) The overprint mode

### has Positional @.Font

(Optional; PDF 1.3) An array of the form [ font size ], where font is an indirect reference to a font dictionary and size is a number expressed in text space units.

### has PDF::ExtGState::XFerFunction $.BG

(Optional) The black-generation function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]

### has PDF::ExtGState::XFerFunction $.BG2

(Optional; PDF 1.3) Same as BG except that the value may also be the name Default, denoting the black-generation function that was in effect at the start of the page If both BG and BG2 are present in the same graphics state parameter dictionary, BG2 takes precedence.

### has PDF::ExtGState::XFerFunction $.UCR

(Optional) The undercolor-removal function, which maps the interval [ 0.0 1.0 ] to the interval [ −1.0 1.0 ]

### has PDF::ExtGState::XFerFunction $.UCR2

(Optional; PDF 1.3) Same as UCR except that the value may also be the name Default, denoting the undercolor-removal function that was in effect at the start of the page.

### has Positional[PDF::ExtGState::XFerFunction] @.TR

(Optional) The transfer function, which maps the interval [ 0.0 1.0 ] to the interval [ 0.0 1.0 ]

### has Positional[PDF::ExtGState::XFerFunction] @.TR2

(Optional; PDF 1.3) Same as TR except that the value may also be the name Default, denoting the transfer function that was in effect at the start of the page.

### has <anon> $.HT

(Optional) The halftone dictionary or stream or the name 'Default'

### has Numeric $.FL

(Optional; PDF 1.3) The flatness tolerance

### has Numeric $.SM

(Optional; PDF 1.3) The smoothness tolerance

### has Bool $.SA

(Optional) A flag specifying whether to apply automatic stroke adjustment

### has Positional[PDF::Class::Defs::BlendMode] @.BM

(Optional; PDF 1.4) The current blend mode to be used in the transparent imaging model

### has PDF::ExtGState::SMaskLike $.SMask

(Optional; PDF 1.4) The current soft mask, specifying the mask shape or mask opacity values to be used in the transparent imaging mode

### has PDF::ExtGState::Alpha $.CA

(Optional; PDF 1.4) The current stroking alpha constant, specifying the constant shape or constant opacity value to be used for stroking operations in the transparent imaging model

### has PDF::ExtGState::Alpha $.ca

(Optional; PDF 1.4) Same as CA, but for nonstroking operations

### has Bool $.AIS

(Optional; PDF 1.4) The alpha source flag (“alpha is shape”), specifying whether the current soft mask and alpha constant are to be interpreted as shape values (true) or opacity values (false).

### has Bool $.TK

(Optional; PDF 1.4) The text knockout flag, which determines the behavior of overlapping glyphs within a text object in the transparent imaging model

### method transparency

```raku
method transparency() returns Mu
```

The graphics transparency , with 0 being fully opaque and 1 being fully transparent. This is a convenience method setting proper values for stroke-alpha and fill-alpha.

### has PDF::ExtGState::BlackPtComp $.UseBlackPtComp

(Optional; PDF 2.0) This graphics state parameter controls whether black point compensation is performed while doing CIE-based colour conversions.

### has Positional[Numeric] @.HTO

(Optional; PDF 2.0) Halftone origin, specified as an array of two numbers specifying the X and Y location of the halftone origin in the current coordinate system.\nAlthough the numbers are specified in the current coordinate system, changes to the current coordinate system (for example as a result of invocation of a form XObject) do not move the halftone origin relative to the underlying device coordinate system.

