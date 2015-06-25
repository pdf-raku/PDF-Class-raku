use v6;

use PDF::DOM::Composition::Text::Block;

class PDF::DOM::Composition::Content {
    has $.parent;
    has @.ops is rw;

    method save(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'q' );
    }

    method restore(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'Q' );
    }

    method text(Str $text,
                :$font is copy = $!parent.core-font('Courier'),
                Numeric :$font-size = 16;
                Str :$align,
                Bool :$dry-run = False,
                Numeric :$top?,
                Numeric :$left?,
                *%etc,  #| :$kern, :$font-size, :$line-height, :$width, :$height
        ) {

        my $text-block = PDF::DOM::Composition::Text::Block.new( :$text, :$font, :$font-size, |%etc );

        $text-block.align( $align )
            if $align.defined
            && $text-block.width
            && $align eq 'left' | 'right' | 'center' | 'justify';

        unless $dry-run {
            @!ops.push: ( 'Tm' => [ :real($top//0), :real($left//0) ] )
                if $top.defined || $left.defined;
            @!ops.push: ( 'Tf' => [ :name($font.key), :real($font-size) ] );
            @!ops.push: $text-block.content.list;
        }

        return $text-block;
    }

    method content {
        use PDF::Writer;
        my $writer = PDF::Writer.new;
        my @content = @!ops;
        $writer.write( :@content );
    }

}
