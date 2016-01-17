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

plan 5;

class MyDelegator is PDF::Doc::Delegator {
    method class-paths {
         <t::Doc PDF::Doc::Type PDF::DAO::Type>
    }
}

PDF::DAO.delegator = MyDelegator;

use t::Doc::Catalog;

my $Catalog = t::Doc::Catalog.new( :dict{ :Type( :name<Catalog> ),
                                          :Version( :name<PDF>) ,
                                          :Pages{ :Type{ :name<Pages> },
                                                  :Kids[],
                                                  :Count(0),
                                                },
                                        },
                                   );

isa-ok $Catalog, t::Doc::Catalog;
is $Catalog.Type, 'Catalog', '$Catalog.Type';

isa-ok $Catalog.Pages, ::('t::Doc::Pages');

# should autoload from t/Doc/Page.pm
my $page = $Catalog.Pages.add-page;

isa-ok $page, ::('t::Doc::Page');

my $form = $page.to-xobject;
isa-ok $form, ::('PDF::Doc::Type::XObject::Form'), 'unextended class';

