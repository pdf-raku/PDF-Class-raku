use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /Catalog - usually the root object in a PDF

class PDF::DOM::Type::Catalog
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Pages is rw { self<Pages> }
    method Outlines is rw { self<Outlines> }
    method Resources is rw { self<Resources> }

    method finish {
        self<Pages>.cb-finish;
    }

}
