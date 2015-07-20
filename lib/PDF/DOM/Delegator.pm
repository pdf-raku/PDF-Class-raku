use v6;

use PDF::Object;
use PDF::Object::Delegator;

class PDF::DOM::Delegator {...}
PDF::Object.delegator = PDF::DOM::Delegator;

class PDF::DOM::Delegator
    is PDF::Object::Delegator {

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

    multi method delegate(Hash :$dict! where {$dict<ShadingType>:exists}) {
	require ::('PDF::DOM::Type::Shading');
	::('PDF::DOM::Type::Shading').delegate( :$dict );
    }

    multi method delegate(Hash :$dict!, *%opts) is default {
	nextwith( :$dict, |%opts);
    }
}
