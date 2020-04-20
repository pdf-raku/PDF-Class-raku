use Test;
plan 6;
use PDF::Class::Defs :ActionSubtype, :AnnotSubtype, :AnnotLike;

cmp-ok 'GoToR', '~~', ActionSubtype;
cmp-ok 'GoToZ', '!~~', ActionSubtype;

cmp-ok 'Popup', '~~', AnnotSubtype;
cmp-ok 'popup','!~~',  AnnotSubtype;
cmp-ok { :Subtype<Popup> }, '~~', AnnotLike;
cmp-ok { :Subtype<popup> }, '!~~', AnnotLike;

