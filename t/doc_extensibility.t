use v6;
use Test;
use PDF::DAO;
use PDF::DAO::Dict;
use PDF::DAO::Type;
use PDF::DAO::Tie;
use PDF::Doc;
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

#| replacement Catalog class - built from scratch
class t::Doc::Catalog
    is PDF::DAO::Dict
    does PDF::DAO::Type {

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::DAO::Name;
    has PDF::DAO::Name $.Version is entry;        #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, /1.4) 
    has Hash $.Pages is entry(:required, :indirect); #| (Required; must be an indirect reference) The page tree node
    has Hash $.Resources is entry;
}

#| subclassed Pages class
use PDF::Doc::Type::Pages;
class t::Doc::Pages is  PDF::Doc::Type::Pages {
}

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

todo "class-paths load - failing :-";
isa-ok $Catalog.Pages, t::Doc::Pages;

# should autoload from t/Doc/Page.pm
my $page = $Catalog.Pages.add-page;

todo "class-paths load - failing :-";
isa-ok $page, ::('t::Doc::Page');

my $form = $page.to-xobject;
isa-ok $form, ::('PDF::Doc::Type::XObject::Form'), 'unextended class';

