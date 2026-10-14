unit class PDF::OCG::PageElement;

use PDF::COS::Dict;
also is PDF::COS::Dict;

use PDF::COS::Tie;
use PDF::COS::Name;

has PDF::COS::Name $.Subtype is entry(:required) where 'HF'|'FG'|'BG'|'L'; #= a name that is either HF (header/footer), FG (foreground image or graphics), BG (background image or graphics), or L (logo).
