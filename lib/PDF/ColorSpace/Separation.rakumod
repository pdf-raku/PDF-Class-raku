unit class PDF::ColorSpace::Separation;

use PDF::ColorSpace;
also is PDF::ColorSpace;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Function;
use PDF::Class::Defs :ColorSpace;

# see [PDF 32000 Section 8.6.6.4 Separation Color Spaces]

has PDF::COS::Name $.Name is index(1);
has ColorSpace $.AlternateSpace is index(2);
has PDF::Function $.TintTransform is index(3);
