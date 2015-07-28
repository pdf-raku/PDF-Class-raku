use v6;

use PDF::DOM::RootObject;
use PDF::Object::Util :to-ast-native;
use PDF::Object::Dict;
use PDF::Object::Tie::Hash;

#| DOM entry-point. either a trailer dict or an XRef stream
class PDF::DOM
    is PDF::Object::Dict
    does PDF::Object::Tie::Hash
    does PDF::DOM::RootObject {

    use PDF::Object::Tie;

    has Int $!Size is entry(:required);   #| 1 greater than the highest object number used in the file.
    use PDF::DOM::Type::Catalog;
    has PDF::DOM::Type::Catalog $!Root is entry(:required,:indirect);
                                          #| (Required; must be an indirect reference) The catalog dictionary for the PDF document contained in the file
    has Hash $!Encrypt is entry;          #| (Required if document is encrypted; PDF 1.1) The document’s encryption dictionary
    has Hash $!Info is entry(:indirect);  #| (Optional; must be an indirect reference) The document’s information dictionary 
    has Array $!ID is entry;              #| (Optional, but strongly recommended; PDF 1.1) An array of two byte-strings constituting a file identifier

    method Pages { self.Root.Pages }
    method page($page-num) { self.Pages.page($page-num) }
    method page-count { self.Pages.Count }
    method add-page { self.Pages.add-page }
    method delete-page($page-num) { self.Pages.delete-page($page-num) }
    method media-box(*@a) { self.Pages.media-box( |@a ) }
    method core-font(*@a, *%o) { self.Pages.core-font( |@a, |%o ) }

    method cb-init {
        self<Root> //= PDF::DOM::Type::Catalog.new;
	self<Size> //= 0;
    }

    method content {
	my %trailer = self.pairs;
	%trailer<Root Prev Size>:delete;
        to-ast-native %trailer;
    }

}
