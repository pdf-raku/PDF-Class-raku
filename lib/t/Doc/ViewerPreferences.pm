use v6;

use PDF::Struct::ViewerPreferences;

role t::Doc::ViewerPreferences
    does PDF::Struct::ViewerPreferences {
	method some-custom-method {'howdy'}
}
