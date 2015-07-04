use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Annot
    is PDF::Object::Dict
    does PDF::DOM::Type {

    method Rect is rw returns Array { self<Rect> }
    method Contents is rw returns Str:_ { self<Contents> }
    method P is rw returns Hash:_ { self<P> }
    method NM is rw returns Str:_ { self<NM> }
    method M is rw returns Str:_ { self<M> }
    method F is rw returns Int:_ { self<F> }
    method AP is rw returns Hash:_ { self<AP> }
    method AS is rw returns Str:_ { self<AS> }
    method Border is rw returns Array:_ { self<Border> }
    method C is rw returns Array:_ { self<C> }
    method StructParent is rw returns Int:_ { self<StructParent> }
    method OC is rw returns Hash:_ { self<OC> }

}
