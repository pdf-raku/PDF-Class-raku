use v6;

use PDF::DOM::Contents::Op;

class PDF::DOM::Contents::Stream 
    does PDF::DOM::Contents::Op {
    has $.parent;

    use PDF::DOM::Contents::Text::Block;
    use PDF::DOM::Type::XObject;
    use PDF::DOM::Type::XObject::Image;

    method save(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'q' );
    }

    method restore(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'Q' );
    }

    method image($spec where Str | PDF::DOM::Type::XObject::Image ) {
        my $image = PDF::DOM::Type::XObject::Image.open( $spec );
        $.parent.resource($image);
        $image;
    }

    #| execute a resource
    method do(PDF::DOM::Type::XObject $obj!,
              Numeric $x!,
              Numeric $y!,
              Numeric :$width is copy,
              Numeric :$height is copy,
              Numeric :$scale = 1.0,
        )  {

        given $obj {
            when PDF::DOM::Type::XObject::Image {
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
            }
            default {
                # Form: width & height are scales
                $width //= 1;
                $height //= 1;
            }
        }

        $.save;
        $.op('cm', $width * $scale, 0, 0, $height * $scale, $x, $y);
        $.op('Do', $.parent.resource($obj).key );
        $.restore;
    }

    method text-move(Numeric $x!, Numeric $y!, Bool :$abs) {
        $.op('Tm', 1, 0, 0, 1, 0, 0) if $abs;
        $.op('Td', $x, $y)
    }

    method text(Str $text,
                :$font is copy = $!parent.core-font('Courier'),
                Numeric :$font-size = 16;
                Str :$align,
                Bool :$dry-run = False,
                *%etc,  #| :$kern, :$font-size, :$line-height, :$width, :$height
        ) {

        my $text-block = PDF::DOM::Contents::Text::Block.new( :$text, :$font, :$font-size, |%etc );

        $text-block.align( $align )
            if $align.defined
            && $text-block.width
            && $align eq 'left' | 'right' | 'center' | 'justify';

        unless $dry-run {
            $.op('Tf', $font.key, $font-size);
            $.ops( $text-block.content );
        }

        return $text-block;
    }

}
