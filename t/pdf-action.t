use v6;
use Test;
use PDF::Class;
use PDF::COS::Name;
use PDF::Action::GoTo;
use PDF::Action::GoToR;
use PDF::Action::URI;
use PDF::Destination :Fit, :DestinationLike;
use PDF::Page;

my PDF::Page() $page = { :Type<Page> };

my PDF::Action::GoTo $goto-named .= COERCE: %( :Type<Action>, :S<GoTo>, :D<Foo> );
is $goto-named.destination, 'Foo', 'named destination';
does-ok $goto-named.destination, PDF::COS::Name;
lives-ok {$goto-named.check};

my PDF::Destination $page-dest .= construct(FitBox, :$page);
my PDF::Action::GoTo $goto-page .= COERCE: %( :Type<Action>, :S<GoTo>, :D($page-dest));
cmp-ok $goto-page.destination, '===', $page-dest;
lives-ok {$goto-page.check};

my PDF::Action::GoToR $goto-named-remote .= COERCE: %( :Type<Action>, :S<GoToR>, :D<Bar>, :F<my.pdf> );
is $goto-named-remote.destination, 'Bar';
lives-ok {$goto-named-remote.check};

my PDF::Destination $page-dest-remote .= construct(FitBox, :page(42));
my PDF::Action::GoToR $goto-page-remote .= COERCE: %( :Type<Action>, :S<GoToR>, :D($page-dest-remote), :F<my.pdf> );
cmp-ok $goto-page-remote.destination, '===', $page-dest-remote;
lives-ok {$goto-page.check};

my PDF::Action::URI() $uri .= COERCE: %( :Type<Action>, :S<URI>, :URI<Hi%E2%98%BA>);
is $uri.URI, 'Hi%E2%98%BA';
lives-ok {$uri.check};

dies-ok {$goto-page-remote.COERCE: %( :Type<Action>, :S<GoToR>, :D($page-dest), :F<my.pdf>).check}, 'remote construction on local page destination - dies';
dies-ok {$goto-page.COERCE: %( :Type<Action>, :S<GoToR>, :D($page-dest-remote), :F<my.pdf>).check;}, 'local construction on remote page destination - dies';

done-testing;
