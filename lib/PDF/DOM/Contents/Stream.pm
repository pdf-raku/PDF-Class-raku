use v6;

use PDF::DOM::Contents::Text::Block;
use PDF::DOM::Type::XObject;
use PDF::DOM::Contents::Op;

class PDF::DOM::Contents::Stream 
    does PDF::DOM::Contents::Op {
    has $.parent;

    method save(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'q' );
    }

    method restore(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'Q' );
    }

    #| execute a resource
    multi method do(PDF::DOM::Type::XObject $obj!)  {
        $.do( $.parent.resource($obj).key );
    }

    #| execute the named xobject form or pattern object
    multi method do(Str $name!) is default  { $.op('Do', $name) }

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
