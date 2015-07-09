use v6;

use PDF::DOM::Contents::Op :OpNames;

class PDF::DOM::Contents::Stream 
    does PDF::DOM::Contents::Op {
    has $.parent;

    use PDF::DOM::Contents::Text::Block;
    use PDF::DOM::Type::XObject;
    use PDF::DOM::Type::XObject::Image;

    method save(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( Save.value );
    }

    method restore(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( Restore.value );
    }

    method block( &do-stuff! ) {
        $.op(Save);
        &do-stuff();
        $.op(Restore);
    }

    method image($spec where Str | PDF::DOM::Type::XObject::Image ) {
        PDF::DOM::Type::XObject::Image.open( $spec );
    }

    #| place an image, or form object
    method do(PDF::DOM::Type::XObject $obj!,
              Numeric $x!,
              Numeric $y!,
              Numeric :$width is copy,
              Numeric :$height is copy,
              Str :$align  where {$_ eq 'left' | 'center' | 'right'}  = 'left',
              Str :$valign where {$_ eq 'top'  | 'center' | 'bottom'} = 'bottom',
              Bool :$inline = False,
        )  {

        my $dx = { :left(0),   :center(-.5), :right(-1) }{$align};
        my $dy = { :bottom(0), :center(-.5), :top(-1)  }{$valign};

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
                my $bbox = .BBox;
                my $obj-width = $bbox[2] - $bbox[0] || 1;
                my $obj-height = $bbox[3] - $bbox[1] || 1;

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

        $.save;
        $.op(ConcatMatrix, $width, 0, 0, $height, $x + $dx, $y + $dy);
        if $inline && $obj.Subtype eq 'Image' {
            # serialize the image to the content stream, aka: :BI[:$dict], :ID[:$stream], :EI[]
            $.ops( $obj.content(:inline) );
        }
        else {
            $.op(XObject, $.parent.resource($obj).key );
        }
        $.restore;
    }

    #| set the current text position on the page/form
    multi method text-move(Numeric $x!, Numeric $y!, Bool :$abs! where $abs) {
        my @tm = @$.TextMatrix;
        @tm[4] = $x;
        @tm[5] = $y;
        $.op(SetTextMatrix, @tm);
    }
    multi method text-move(Numeric $x!, Numeric $y!) is default {
        $.op(TextMove, $x, $y)
    }

    #| thin wrapper to $.op(SetFont, ...)
    method set-font( $font-entry! is copy, Numeric $size!) {
        $font-entry = $font-entry.key if $font-entry.can('key');
        $.op(SetFont, $font-entry, $size);
    }

    #! output text leave the text position at the end of the current line
    method print(Str $text,
                 :$font is copy,
                 Numeric :$font-size = $.FontSize || 16;
                 Numeric :$word-spacing = $.WordSpacing,
                 Bool :$dry-run = False,
                 Bool :$nl = False,
                 *%etc,  #| :$align, :$kern, :$line-height, :$width, :$height
        ) {
        $font //= $.parent.resource-entry('Font', $.FontKey)
            if $.FontKey;
        $font //= $!parent.core-font('Courier');
            
        my $text-block = PDF::DOM::Contents::Text::Block.new( :$text, :$font, :$font-size, :$word-spacing, |%etc );

        unless $dry-run {
            $.op(SetFont, $font.key, $font-size)
                unless $.FontKey
                && $font.key eq $.FontKey
                && $font-size == $.FontSize;
            $.ops( $text-block.content(:$nl) );
        }

        return $text-block;
    }

    #! output text move the  text position down one line
    method say($text, *%opt) {
        $.print($text, :nl, |%opt);
    }

}
