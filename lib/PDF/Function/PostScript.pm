use v6;

use PDF::Function;

#| /FunctionType 4 - PostScript
# see [PDF 1.7 Section 3.9.4 Type 4 (PostScript Calculator) Functions]
class PDF::Function::PostScript
    is PDF::Function {

    method parse(Str $decoded = $.decoded) {
	require PDF::Grammar::Function;
	require PDF::Grammar::Function::Actions;
	state $actions //= ::('PDF::Grammar::Function::Actions').new;
	::('PDF::Grammar::Function').parse($decoded, :$actions)
	    or die "unable to parse postscript function: $decoded";
	$/.ast
    }

}
