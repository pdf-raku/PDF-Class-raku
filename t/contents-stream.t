use v6;
use Test;
use PDF::DOM::Contents::Stream;
plan 4;

my $gfx = PDF::DOM::Contents::Stream.new;

lives-ok {$gfx.op('Tj' => [ :literal('Hello, world!') ])}, 'push raw content';
lives-ok {$gfx.op('TJ' => [[ 'bye', :hex-string('bye') ]])}, 'push raw content';
$gfx.save( :prepend );
$gfx.restore;
is-deeply $gfx.ops, [
    'q',
    :Tj[ :literal('Hello, world!') ],
    :TJ[ :array[ :literal("bye"), :hex-string('bye') ] ],
    'Q',
    ], 'content ops';

my $content = $gfx.content;

is-deeply [$content.lines], ['q', '(Hello, world!) Tj', '[ (bye) <627965> ] TJ', 'Q'], 'rendered content';


