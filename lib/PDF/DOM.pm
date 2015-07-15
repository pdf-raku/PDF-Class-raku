use v6;

use PDF::DOM::RootObject;
use PDF::Object :to-ast-native;
use PDF::Object::Dict;
use PDF::Object::Tie::Hash;

#| DOM entry-point. either a trailer dict or an XRef stream
class PDF::DOM
    is PDF::Object::Dict
    does PDF::Object::Tie::Hash
    does PDF::DOM::RootObject {

    use PDF::DOM::Type::Catalog;
    has PDF::DOM::Type::Catalog $!Root;   method Root { self.tie($!Root) };
    has Numeric $!Size;                   method Size { self.tie($!Root) };
    has Array:_ $ID;                      method ID   { self.tie($!ID) };
    has Hash:_ $Info;                     method Info { self.tie($!Info) };

    method new {
	my $obj = callsame;
        $obj<Root> //= PDF::DOM::Type::Catalog.new;
        $obj<Size> //= 0;
	$obj;
    }

    method Pages { self.Root.Pages }
    method page($page-num) { self.Pages.page($page-num) }
    method page-count { self.Pages.Count }
    method add-page { self.Pages.add-page }
    method delete-page($page-num) { self.Pages.delete-page($page-num) }
    method media-box(*@a) { self.Pages.media-box( |@a ) }
    method core-font(*@a, *%o) { self.Pages.core-font( |@a, |%o ) }

    method content {
	my %trailer = self.pairs;
	%trailer<Root Prev Size>:delete;
        to-ast-native %trailer;
    }

}
