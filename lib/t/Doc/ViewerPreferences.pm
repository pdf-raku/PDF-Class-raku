use v6;

use PDF::Doc::Type::ViewerPreferences;

role t::Doc::ViewerPreferences
    does PDF::Doc::Type::ViewerPreferences {
	method some-custom-method {'howdy'}
}
