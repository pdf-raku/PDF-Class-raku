use v6;

use PDF::Object;
use PDF::Object::Delegator;

class PDF::DOM::Delegator {...}
PDF::Object.delegator = PDF::DOM::Delegator;

class PDF::DOM::Delegator
    is PDF::Object::Delegator {

    use PDF::Object::Util :from-ast;

    multi method find-delegate( Str :$subclass! where 'XRef' | 'ObjStm', :$fallback) {
	require ::('PDF::Object::Type')::($subclass);
	my $handler-class = ::('PDF::Object::Type')::($subclass);
        self.install-delegate( :$subclass, :$handler-class );
    }

    multi method find-delegate( Str :$subclass!, :$fallback!) is default {

        my $handler-class = $fallback;
        my $resolved;
	my $error;
	my $class-path = 'PDF::DOM::Type';

	try {
	    require ::($class-path)::($subclass);
	    $handler-class = ::($class-path ~ '::' ~ $subclass);
	    $resolved = True;
	}
		
        unless $resolved {
           note "No DOM handler class {$class-path}::{$subclass}";
        }

        self.install-delegate( :$subclass, :$handler-class );
    }

    multi method delegate(Hash :$dict! where {$dict<FunctionType>:exists}) {
	require ::('PDF::DOM::Type::Function');
	::('PDF::DOM::Type::Function').delegate( :$dict );
    }

    multi method delegate(Hash :$dict! where {$dict<PatternType>:exists}) {
	warn "pattern delegation...";
	require ::('PDF::DOM::Type::Pattern');
	::('PDF::DOM::Type::Pattern').delegate( :$dict );
    }

    multi method delegate(Hash :$dict! where {$dict<ShadingType>:exists}) {
	require ::('PDF::DOM::Type::Shading');
	::('PDF::DOM::Type::Shading').delegate( :$dict );
    }

    multi method delegate(Hash :$dict!, *%opts) is default {
	nextwith( :$dict, |%opts);
    }

    #| PDF Spec 1.7 Section 4.5.4 CIE-Based Color Spaces
    subset CIEBased-ColorSpace of Array where {
	.elems == 2 && do {
	    my $t = from-ast .[0];
	    $t ~~ Str && $t eq 'CalGray'|'CalRGB'|'Lab' && do {
		my $d = from-ast .[1];
		($d ~~ Hash) && ($d<WhitePoint>:exists);
	    }
	}
    }

    multi method delegate(CIEBased-ColorSpace :$array!, *%opts) {
	my $colorspace = from-ast $array[0];
	require ::('PDF::DOM::Array::ColorSpace')::($colorspace);
	::('PDF::DOM::Array::ColorSpace')::($colorspace);
    }

}
