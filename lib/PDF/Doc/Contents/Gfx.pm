use v6;

use PDF::Graphics;
use PDF::Graphics::Ops :OpNames;

class PDF::Doc::Contents::Gfx 
    is PDF::Graphics {
    has $.parent;

    use PDF::Doc::Type::XObject;
    use PDF::Doc::Type::XObject::Image;
    method do(PDF::Doc::Type::XObject $obj, Str :$key = $.parent.use-resource($obj).key, |c) {
        nextwith( $obj, :$key, |c);
    }

    #| thin wrapper to $.op(SetFont, ...)
    method set-font( $font-entry!, Numeric $size = 16) {
        my Str $font-key = $font-entry.can('key')
	    ?? $font-entry.key
	    !! $font-entry;
        $.op(SetFont, $font-key, $size);
    }

    use PDF::Doc::Type::ExtGState;
    method set-graphics($gs = PDF::Doc::Type::ExtGState.new,
			Numeric :$opacity,
			*%settings,
	) {

	$gs.transparancy = 1 - $opacity
	    if $opacity.defined;

	for %settings.keys.sort {
	    if $gs.can($_) {
		$gs."$_"() = %settings{$_}
	    }
	    else {
		warn "ignoring graphics state option: $_";
	    }
	}

	my $gs-entry = self.parent.use-resource($gs, :eqv);
	self.SetGraphicsState($gs-entry.key);
    }

    method !get-font {
       my $font = $.parent.resource-entry('Font', $.FontKey)
           if $.FontKey;
       $font // $!parent.core-font('Courier');
    }

    multi method print(Str $text, :$font = self!get-font, |c) {
        nextwith( $text, :$font, |c);
    }

}
