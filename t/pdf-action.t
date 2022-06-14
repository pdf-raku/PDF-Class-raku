use v6;
use Test;
use PDF::Class;
use PDF::Action::GoTo;
use PDF::Action::GoToR;
use PDF::Action::URI;
use PDF::Destination :Fit, :DestinationLike;
use PDF::Page;

my PDF::Page() $page = { :Type<Page> };

my PDF::Action::GoTo $goto-named .= construct: :destination<Foo>;
is $goto-named.destination, 'Foo', 'named destination';

my PDF::Destination $page-dest .= construct(FitBox, :$page);
my PDF::Action::GoTo $goto-page .= construct: :destination($page-dest);
cmp-ok $goto-page.destination, '===', $page-dest;

my PDF::Action::GoToR $goto-named-remote .= construct: :destination<Bar>, :file<my.pdf>;;
is $goto-named-remote.destination, 'Bar';

my PDF::Destination $page-dest-remote .= construct(FitBox, :page(42));
my PDF::Action::GoToR $goto-page-remote .= construct: :destination($page-dest-remote), :file<my.pdf>;
cmp-ok $goto-page-remote.destination, '===', $page-dest-remote;

dies-ok {$goto-page-remote.construct: :destination($page-dest), :file<my.pdf>;}, 'remote construction on local destination - dies';
dies-ok {$goto-page.construct: :destination($page-dest-remote), :file<my.pdf>;}, 'local construction on remote destination - dies';


my PDF::Action::URI() $uri .= construct: :uri<Hi☺>;
is $uri.URI, 'Hi%E2%98%BA';

done-testing;
