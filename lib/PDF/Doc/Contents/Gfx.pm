use v6;

use PDF::Graphics;
use PDF::Graphics::Ops :OpNames, :GraphicsContext;

class PDF::Doc::Contents::Gfx 
    is PDF::Graphics {
    has $.parent;

    use PDF::Graphics::Text::Block;

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

    #! output text leave the text position at the end of the current line
    multi method print(Str $text,
		       Bool :$stage = False,
		       :$font is copy,
		       |c,  #| :$align, :$kern, :$line-height, :$width, :$height
        ) {
	# detect and use the current text-state font
        $font //= $.parent.resource-entry('Font', $.FontKey)
            if $.FontKey;
        $font //= $!parent.core-font('Courier');
	my Numeric $font-size = $.FontSize || 16;
	my Numeric $word-spacing = $.WordSpacing;
	my Numeric $horiz-scaling = $.HorizScaling;
	my Numeric $char-spacing = $.CharSpacing;

        my $text-block = PDF::Graphics::Text::Block.new( :$text, :$font, :$font-size,
                                                         :$word-spacing, :$horiz-scaling, :$char-spacing,
                                                         |c );

	$.print( $text-block, |c)
	    unless $stage;

	$text-block;
    }

    multi method print(PDF::Graphics::Text::Block $text-block,
		       Bool :$nl = False,
	) {

	my $font-size = $text-block.font-size;
	my $font-key = $text-block.font-key;

	my Bool $in-text = $.context == GraphicsContext::Text;
	$.op(BeginText) unless $in-text;

	$.op(SetFont, $font-key, $font-size)
	    unless $.FontKey
	    && $font-key eq $.FontKey
	    && $font-size == $.FontSize;
	$.ops( $text-block.content(:$nl) );

	$.op(EndText) unless $in-text;

        $text-block;
    }

    #! output text move the  text position down one line
    method say($text, |c) {
        $.print($text, :nl, |c);
    }

}
