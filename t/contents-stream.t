use v6;
use Test;
use PDF::Grammar::Test :is-json-equiv;
use PDF::DOM::Contents::Stream;
use PDF::DOM::Contents::Op :OpNames;
plan 6;

my $gfx = PDF::DOM::Contents::Stream.new;

lives-ok {$gfx.op(BeginText)}, 'basic op';
lives-ok {$gfx.op('Tj' => [ :literal('Hello, world!') ])}, 'push raw content';
lives-ok {$gfx.op('TJ' => [[ 'bye', :hex-string('bye') ]])}, 'push raw content';
dies-ok {$gfx.op('Tjunk' => [ :literal('wtf?') ])}, "can't push bad raw content";
$gfx.op('ET');
$gfx.save( :prepend );
$gfx.restore;
is-json-equiv $gfx.ops, [
    'q',
    :BT[],
    :Tj[ :literal('Hello, world!') ],
    :TJ[ :array[ :literal("bye"), :hex-string('bye') ] ],
    :ET[],
    'Q',
    ], 'content ops';

my $content = $gfx.content;

is-json-equiv [$content.lines], ['q', 'BT', '(Hello, world!) Tj', '[ (bye) <627965> ] TJ', 'ET', 'Q'], 'rendered content';


