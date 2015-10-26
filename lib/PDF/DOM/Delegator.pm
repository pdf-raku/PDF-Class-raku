use v6;

use PDF::DAO;
use PDF::DAO::Name;
use PDF::DAO::Delegator;

class PDF::DOM::Delegator {...}
PDF::DAO.delegator = PDF::DOM::Delegator;

class PDF::DOM::Delegator
    is PDF::DAO::Delegator {

    use PDF::DAO::Util :from-ast;

    method class-paths {<PDF::DOM::Type PDF::DAO::Type>}

    multi method find-delegate( Str $subclass! where { self.handler{$_}:exists } ) {
        self.handler{$subclass}
    }

    multi method find-delegate( Str $subclass! where 'XRef' | 'ObjStm') {
	require ::('PDF::DAO::Type')::($subclass);
	self.install-delegate( $subclass, ::('PDF::DAO::Type')::($subclass) );
    }

    multi method find-delegate( Str $subclass!, :$fallback!) is default {

        my $handler-class = $fallback;
        my Bool $resolved;

	for self.class-paths -> $class-path {
	    try {
		try { require ::($class-path)::($subclass) };
		$handler-class = ::($class-path)::($subclass);
		$resolved = True;
	    }
	    last if $resolved;
	}
		
        unless $resolved {
           note "No DOM handler class {self.class-paths}::{$subclass}";
        }

        self.install-delegate( $subclass, $handler-class );
    }

    multi method delegate(Hash :$dict! where {$dict<FunctionType>:exists}) {
	require ::('PDF::DOM::Type::Function');
	::('PDF::DOM::Type::Function').delegate-function( :$dict );
    }

    multi method delegate(Hash :$dict! where {$dict<PatternType>:exists}) {
	require ::('PDF::DOM::Type::Pattern');
	::('PDF::DOM::Type::Pattern').delegate-pattern( :$dict );
    }

    multi method delegate(Hash :$dict! where {$dict<ShadingType>:exists}) {
	require ::('PDF::DOM::Type::Shading');
	::('PDF::DOM::Type::Shading').delegate-shading( :$dict );
    }

    multi method delegate(Hash :$dict! where {($dict<Registry>:exists) && ($dict<Ordering>:exists)}) {
	require ::('PDF::DOM::Type::CIDSystemInfo');
	::('PDF::DOM::Type::CIDSystemInfo');
    }

    multi method delegate(Hash :$dict!, *%opts) is default {
	nextwith( :$dict, |%opts);
    }

    #| PDF Spec 1.7 Section 4.5.4 CIE-Based Color Spaces
    subset ColorSpace-Array-CIE where {
	.elems == 2 && do {
	    my $t = from-ast .[0];
	    if $t ~~  PDF::DAO::Name {
		my $d = from-ast .[1];
		$d ~~ Hash && do given $t {
		    when 'CalGray'|'CalRGB'|'Lab' { $d<WhitePoint>:exists}
		    when 'ICCBased'               { $d<N>:exists }
		    default {False}
		}
	    }
	}
    }

    #| PDF Spec 1.7 Section 4.5.5 Special Color Spaces
    subset ColorSpace-Array-Special where {
	my $a = $_;
	$a.elems == 4 && do {
	    my $t = from-ast $a[0];
	    $t ~~  PDF::DAO::Name && do given $t {
		when 'Indexed'    { my $hival = from-ast($a[2]); $hival ~~ UInt }
		when 'Separation' { from-ast($a[1]) ~~ PDF::DAO::Name }
		default {False}
	    }
	}
    }

    subset ColorSpace-Array of Array where ColorSpace-Array-CIE | ColorSpace-Array-Special;

    multi method delegate(ColorSpace-Array :$array!, *%opts) {
	my $colorspace = from-ast $array[0];
	require ::('PDF::DOM::Type::ColorSpace')::($colorspace);
	::('PDF::DOM::Type::ColorSpace')::($colorspace);
    }

}
