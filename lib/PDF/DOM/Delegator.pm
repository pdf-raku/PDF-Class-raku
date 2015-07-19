use v6;

use PDF::Object;
use PDF::Object::Delegator;

class PDF::DOM::Delegator {...}
PDF::Object.delegator = PDF::DOM::Delegator;

class PDF::DOM::Delegator
    is PDF::Object::Delegator {

    multi method find-delegate( Str :$subclass!, :$fallback!) is default {

        my $handler-class = $fallback;
        my $resolved;
	my $error;
	my $class-path = 'PDF::DOM::Type';

	do {
	    require ::($class-path)::($subclass);
	    $handler-class = ::($class-path ~ '::' ~ $subclass);
	    $resolved = True;

	    CATCH {
		default { warn $_ }
	    }
	}
		
        unless $resolved {
            warn "No DOM handler class {$class-path}::{$subclass}";
        }

        self.install-delegate( :$subclass, :$handler-class );
    }

    method delegate(*%opts) {
	nextwith(:class-path<PDF::DOM::Type>, |%opts);
    }
}
