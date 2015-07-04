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

    method block( &do-stuff! ) {
        $.op('q');
        &do-stuff();
        $.op('Q');
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
              Str :$align  where {$_ eq 'left' | 'center' | 'right'}  = 'left',
              Str :$valign where {$_ eq 'top'  | 'center' | 'bottom'} = 'bottom',
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
        $.op('cm', $width, 0, 0, $height, $x + $dx, $y + $dy);
        $.op('Do', $.parent.resource($obj).key );
        $.restore;
    }

    method text-move(Numeric $x!, Numeric $y!, Bool :$abs) {
        $.op('Tm', 1, 0, 0, 1, 0, 0) if $abs;
        $.op('Td', $x, $y)
    }

    method print(Str $text,
                 :$font is copy = $!parent.core-font('Courier'),
                 Numeric :$font-size = 16;
                 Bool :$dry-run = False,
                 Bool :$nl = False,
                 *%etc,  #| :$align, :$kern, :$font-size, :$line-height, :$width, :$height
        ) {

        my $text-block = PDF::DOM::Contents::Text::Block.new( :$text, :$font, :$font-size, |%etc );

        unless $dry-run {
            $.op('Tf', $font.key, $font-size);
            $.ops( $text-block.content(:$nl) );
        }

        return $text-block;
    }

    method say($text, *%opt) {
        $.print($text, :nl, |%opt);
    }

}
