use v6;

class PDF::DOM::Util::Content {
    has @.content is rw;

     method g-save(Bool :$prepend) {
         @!content."{$prepend ?? 'unshift' !! 'push'}"( 'q' );
     }

     method g-restore(Bool :$prepend) {
         @!content."{$prepend ?? 'unshift' !! 'push'}"( 'Q' );
     }

}
