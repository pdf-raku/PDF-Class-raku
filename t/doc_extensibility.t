use v6;
use Test;
use PDF::Doc::Delegator;

=begin pod

=head1 Doc Extensiblity Tests

** Experimental Feature **

These tests check for the ability for users to define and autoload Doc
extension classes

=cut

=end pod

plan 10;

class MyDelegator is PDF::Doc::Delegator {
    method class-paths {
         <t::Doc PDF::Doc::Type PDF::DAO::Type>
    }
}

PDF::DAO.delegator = MyDelegator;

use t::Doc::Catalog;

my $Catalog = t::Doc::Catalog.new( :dict{ :Type( :name<Catalog> ),
                                          :Version( :name<1.3>) ,
                                          :Pages{ :Type{ :name<Pages> },
                                                  :Kids[],
                                                  :Count(0),
                                                },
					  :ViewerPreferences{ :HideToolbar(True) },
                                        },
                                   );

isa-ok $Catalog, t::Doc::Catalog;
is $Catalog.Type, 'Catalog', '$Catalog.Type';
is $Catalog.Version, '1.3', '$Catalog.Version';

# view preferences is a role
my $viewer-preferences;
todo "rakudo symbol merge issues. losing some attributes", 4;
lives-ok {$viewer-preferences = $Catalog.ViewerPreferences}, '$Catalog.ViewerPreferences';
does-ok $viewer-preferences, ::('t::Doc::ViewerPreferences'), '$Catalog.ViewerPreferences';
ok try { $viewer-preferences.HideToolBar }, '$Catalog.ViewerPreferences.HideToolBar';
is try { $viewer-preferences.some-custom-method }, 'howdy', '$Catalog.ViewerPreferences.some-custom-method';

isa-ok $Catalog.Pages, ::('t::Doc::Pages');

# should autoload from t/Doc/Page.pm
my $page = $Catalog.Pages.add-page;

isa-ok $page, ::('t::Doc::Page');

my $form = $page.to-xobject;
isa-ok $form, ::('PDF::Doc::Type::XObject::Form'), 'unextended class';

