use v6;
use Test;
use PDF::Class;
use PDF::Destination :Fit, :DestinationLike;
use PDF::Action::GoTo;
use PDF::Action::GoToR;
use PDF::Page;
use PDF::COS::Name;

multi sub is-destination(PDF::Destination $dest, $expected, $reason = 'destination') {
    use PDF::Grammar::Test :is-json-equiv;
    $dest.check;
    is-json-equiv($dest, $expected, $reason);
}
multi sub is-destination($_, $, $reason) is default {
    flunk($reason);
    note "{.raku} is not a valid destination";
}

my PDF::Page $page .= new: :dict{ :Type<Page> };
my $dest = [$page, 'Fit'];

ok $dest ~~ DestinationLike, 'is destination array';
ok [$page, 'Blah'] !~~ DestinationLike, 'non-destination array';

my PDF::Destination $d;
is-destination $d=PDF::Destination.construct(FitWindow, :$page), [$page, FitWindow], 'FitWindow destination';
is-deeply $d.page, $page, 'page accessor';
is $d.fit, 'Fit', 'fit accessor';
is $d.is-page-ref, True, 'destination is page ref';
does-ok $d.fit, PDF::COS::Name, 'fit accessor';
is-deeply $d.content, (:array($[:dict{:Type(:name<Page>)}, :name<Fit>])), 'destination content';

is-destination $d=PDF::Destination.construct(:$page), [$page, FitWindow], 'Default destination';
is-deeply $d.page, $page, 'page accessor';
is $d.fit, 'Fit', 'fit accessor';
is $d.is-page-ref, True, 'destination is page ref';
does-ok $d.fit, PDF::COS::Name, 'fit accessor';
is-deeply $d.content, (:array($[:dict{:Type(:name<Page>)}, :name<Fit>])), 'destination content';

is-destination $d=PDF::Destination.construct(:page(3)), [3, FitWindow], 'page number destination';
is-deeply $d.page, 3, 'page-number page accessor';
is $d.fit, 'Fit', 'page-number fit accessor';
is $d.is-page-ref, False, 'destination is page ref';
does-ok $d.fit, PDF::COS::Name, 'fit accessor';
is-deeply $d.content, (:array($[3, :name<Fit>])), 'destination content';

is-destination $d=PDF::Destination.construct(FitXYZoom, :$page, :left(42), :top(99), :zoom(1.5)), [$page, FitXYZoom, 42, 99, 1.5], 'FitXYZoom destination';
is $d.left, 42, 'left accessor';
is $d.top, 99, 'top accessor';
is $d.zoom, 1.5, 'zoom accessor';

is-destination $d=PDF::Destination.construct(FitHoriz, :$page, :top(99), ), [$page, FitHoriz, 99,], 'FitHoriz destination';
is $d.top, 99, 'top accessor';

is-destination $d=PDF::Destination.construct(FitVert, :$page, :left(42), ), [$page, FitVert, 42,], 'FitVert destination';
is $d.left, 42, 'left accessor';

is-destination $d=PDF::Destination.construct(FitRect, :$page, :left(42), :top(99), :bottom(10), :right(100)), [$page, FitRect, 42, 10, 100, 99], 'FitRect destination';
is $d.left, 42, 'left accessor';
is $d.top, 99, 'top accessor';
is $d.bottom, 10, 'bottom accessor';
is $d.right, 100, 'right accessor';

is-destination $d=PDF::Destination.construct(FitBox, :$page), [$page, FitBox], 'FitBox destination';
is $d.fit, FitBox, 'fit accessor';

my PDF::Action::GoTo $goto .= construct: :destination<Foo>;
is $goto.destination, 'Foo';
$goto .= construct: :destination($d);
cmp-ok $goto.destination, '===', $d;

my PDF::Destination $d-remote .= construct(FitBox, :page(42));
is-destination($d-remote, [42, FitBox], 'FitBox remote destination');
is $d-remote.is-page-ref, False, 'destination is not a page ref';
is $d-remote.page, 42, 'destination page';
is $d-remote.fit, FitBox, 'fit accessor';

my PDF::Action::GoToR $goto-r .= construct: :destination<Bar>, :file<my.pdf>;;
is $goto-r.destination, 'Bar';
$goto-r .= construct: :destination($d-remote), :file<my.pdf>;
cmp-ok $goto-r.destination, '===', $d-remote;

dies-ok {$goto-r.construct: :destination($d), :file<my.pdf>;}, 'remote construction on local destination - dies';
dies-ok {$goto.construct: :destination($d-remote), :file<my.pdf>;}, 'local construction on remote destination - dies';

done-testing;
