use v6;

class PDF::DOM::Composition::Content {
    has $.parent;
    has @.ops is rw;

    method save(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'q' );
    }

    method restore(Bool :$prepend) {
        @!ops."{$prepend ?? 'unshift' !! 'push'}"( 'Q' );
    }

    method content {
        use PDF::Writer;
        my $writer = PDF::Writer.new;
        my @content = @!ops;
        $writer.write( :@content );
    }

}
