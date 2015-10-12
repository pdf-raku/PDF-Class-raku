use v6;
use Test;
use PDF::DAO;
use PDF::DAO::Dict;
use PDF::DAO::Type;
use PDF::DAO::Tie;
use PDF::DOM;
use PDF::DOM::Delegator;
use lib '.';

=begin pod

=head1 DOM Extensiblity Tests

** Experimental Feature **

These tests check for the ability for users to define and autoload DOM
extension classes

=cut

=end pod

plan 5;

class MyDelegator is PDF::DOM::Delegator {
    method class-paths {<t::DOM PDF::DOM::Type PDF::DAO::Type>}
}

PDF::DAO.delegator = MyDelegator;

#| replacement Catalog class - built from scratch
class t::DOM::Catalog
    is PDF::DAO::Dict
    does PDF::DAO::Type {

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::DAO::Name;
    has PDF::DAO::Name $.Version is entry;        #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, /1.4) 
    has Hash $.Pages is entry(:required, :indirect); #| (Required; must be an indirect reference) The page tree node
    has Hash $.Resources is entry;
}

#| subclassed Pages class
use PDF::DOM::Type::Pages;
class t::DOM::Pages is  PDF::DOM::Type::Pages {
}

my $Catalog = t::DOM::Catalog.new( :dict{ :Type( :name<Catalog> ), :Version( :name<PDF>) , :Pages{ :Type{ :name<Pages> }, :Kids[], :Count(0) } } );

isa-ok $Catalog, t::DOM::Catalog;
is $Catalog.Type, 'Catalog', '$Catalog.Type';
isa-ok $Catalog.Pages, t::DOM::Pages;

# should autoload from t/DOM/Page.pm
my $page = $Catalog.Pages.add-page;
isa-ok $page, ::('t::DOM::Page');

my $form = $page.to-xobject;
isa-ok $form, ::('PDF::DOM::Type::XObject::Form'), 'unextended class';

