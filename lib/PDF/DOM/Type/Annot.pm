use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Contents is rw { self<Contents> }
    method Rect is rw { self<Rect> }
    method P is rw { self<P> }
    method NM is rw { self<NM> }
    method M is rw { self<M> }
    method F is rw { self<F> }
    method AP is rw { self<AP> }
    method AS is rw { self<AS> }
    method Border is rw { self<Border> }
    method C is rw { self<C> }
    method StructParent is rw { self<StructParent> }
    method OC is rw { self<OC> }

}
