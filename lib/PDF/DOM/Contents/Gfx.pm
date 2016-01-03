use v6;

use PDF::DOM::Op :OpNames;

class PDF::DOM::Contents::Gfx 
    does PDF::DOM::Op {
    has $.parent;

    use PDF::DOM::Contents::Text::Block;
    use PDF::DOM::Type::XObject;
    use PDF::DOM::Type::XObject::Image;

    method block( &do-stuff! ) {
        $.op(Save);
        &do-stuff(self);
        $.op(Restore);
    }

    method text( &do-stuff! ) {
        $.op(BeginText);
        &do-stuff(self);
        $.op(EndText);
    }

    method load-image(Str $spec ) {
        PDF::DOM::Type::XObject::Image.open( $spec );
    }

    method inline-images {
	my PDF::DOM::Type::XObject::Image @images;
	for $.ops.keys -> $i {
	    my $v = $.ops[$i];
	    next unless $v.key eq 'BI';

	    my $dict = $v.value[0]<dict>;
	    my $v1 = $.ops[$i+1];
	    die "BI not followed by ID image in content stream"
		unless $v1 && $v1.key eq 'ID';
	    my $encoded = $v1.value[0]<encoded>;

	    @images.push: PDF::DOM::Type::XObject::Image.new( :$dict, :$encoded );
	}
	@images;
    }

    my subset Align of Str where 'left' | 'center' | 'right';
    my subset Valign of Str where 'top'  | 'center' | 'bottom';

    #| place an image, or form object
    method do(PDF::DOM::Type::XObject $obj!,
              Numeric $x = 0,
              Numeric $y = 0,
              Numeric :$width is copy,
              Numeric :$height is copy,
              Align   :$align  = 'left',
              Valign  :$valign = 'bottom',
              Bool    :$inline = False,
        )  {

        my Numeric $dx = { :left(0),   :center(-.5), :right(-1) }{$align};
        my Numeric $dy = { :bottom(0), :center(-.5), :top(-1)   }{$valign};

        given $obj {
            when .Subtype eq 'Image' {
                if $width.defined {
                    $height //= $width * ($obj.Height / $obj.Width);
                }
                elsif $height.defined {
                    $width //= $height * ($obj.Width / $obj.Height);
                }
                else {
                    $width = $obj.Width;
                    $height = $obj.Height;
                }

                $dx *= $width;
                $dy *= $height;
            }
            when .Subtype eq 'Form' {
                my Array $bbox = .BBox;
                my Numeric $obj-width = $bbox[2] - $bbox[0] || 1;
                my Numeric $obj-height = $bbox[3] - $bbox[1] || 1;

                if $width.defined {
                    $height //= $width * ($obj-height / $obj-width);
                }
                elsif $height.defined {
                    $width //= $height * ($obj-width / $obj-height);
                }
                else {
                    $width = $obj-width;
                    $height = $obj-height;
                }

                $dx *= $width;
                $dy *= $height;

                $width /= $obj-width;
                $height /= $obj-height;

            }
            default { die "not an xobject form or image: {.perl}" }
        }

        self.block: {
	    $.op(ConcatMatrix, $width, 0, 0, $height, $x + $dx, $y + $dy);
	    if $inline && $obj.Subtype eq 'Image' {
		# serialize the image to the content stream, aka: :BI[:$dict], :ID[:$stream], :EI[]
		$.ops( $obj.content(:inline) );
	    }
	    else {
		$.op(XObject, $.parent.use-resource($obj).key );
	    }
        };
    }

    use PDF::DOM::Util::TransformMatrix;
    method transform( *%transforms ) {
	my @transform-matrix = PDF::DOM::Util::TransformMatrix::transform-matrix( |%transforms );
	$.ConcatMatrix( @transform-matrix );
    }

    method text-transform( *%transforms ) {
	my @transform-matrix = PDF::DOM::Util::TransformMatrix::transform-matrix( |%transforms );
	$.SetTextMatrix( @transform-matrix );
    }

    my subset Vector of List where {.elems == 2 && .[0] ~~ Numeric && .[1] ~~ Numeric}
    #| set the current text position on the page/form
    method text-position is rw returns Vector {
	my $gfx = self;
	my Numeric @tm = @$.TextMatrix;
	Proxy.new(
	    FETCH => method {
		@tm[4,5]
	    },
	    STORE => method (Vector $v) {
		@tm[4, 5] = @$v;
		$gfx.op(SetTextMatrix, @tm);
		@$v;
	    },
	    );
    }

    #| thin wrapper to $.op(SetFont, ...)
    method set-font( $font-entry!, Numeric $size = 16) {
        my Str $font-key = $font-entry.can('key')
	    ?? $font-entry.key
	    !! $font-entry;
        $.op(SetFont, $font-key, $size);
    }

    use PDF::DOM::Type::ExtGState;
    method set-graphics($gs = PDF::DOM::Type::ExtGState.new,
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

        my $text-block = PDF::DOM::Contents::Text::Block.new( :$text, :$font, :$font-size,
							      :$word-spacing, :$horiz-scaling, :$char-spacing,
							      |c );

	$.print( $text-block, |c)
	    unless $stage;

	$text-block;
    }

    multi method print(PDF::DOM::Contents::Text::Block $text-block,
		       Bool :$nl = False,
	) {

	my $font-size = $text-block.font-size;
	my $font-key = $text-block.font-key;

	my Bool $in-text = $.in-text-block;
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
