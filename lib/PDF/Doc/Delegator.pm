use v6;

use PDF::DAO;
use PDF::DAO::Name;
use PDF::DAO::Delegator;

class PDF::Doc::Delegator {...}
PDF::DAO.delegator = PDF::Doc::Delegator;

class PDF::Doc::Delegator
    is PDF::DAO::Delegator {

    use PDF::DAO::Util :from-ast;

    method class-paths {<PDF::Doc::Type PDF::DAO::Type>}

    method find-delegate( Str $type!, $subtype?, :$fallback) is default {

	my $subclass = $type;
	$subclass ~= '::' ~ $subtype if $subtype;

	return self.handler{$subclass}
	    if self.handler{$subclass}:exists;

        my $handler-class = $fallback;
        my Bool $resolved;

	for self.class-paths -> $class-path {
            require ::($class-path)::($subclass);
            $handler-class = ::($class-path)::($subclass);
            $resolved = True;
            last;
            CATCH {
                when X::CompUnit::UnsatisfiedDependency {
		    # try loading just the parent class
		    $handler-class = $.find-delegate($type, :$fallback)
			if $subtype;
		}
            }
	}
		
	note "No Doc handler class [{self.class-paths}]::{$subclass}"
	    unless $resolved;

        self.install-delegate( $subclass, $handler-class );
    }

    multi method delegate(Hash :$dict! where {.<FunctionType>:exists}) {
	$.find-delegate('Function').delegate-function( :$dict );
    }

    multi method delegate(Hash :$dict! where {.<PatternType>:exists}) {
	$.find-delegate('Pattern').delegate-pattern( :$dict );
    }

    multi method delegate(Hash :$dict! where {.<ShadingType>:exists}) {
	$.find-delegate('Shading').delegate-shading( :$dict );
    }

    multi method delegate(Hash :$dict! where {(.<Registry>:exists) && (.<Ordering>:exists)}) {
	$.find-delegate('CIDSystemInfo');
    }

    multi method delegate( Hash :$dict! where {.<Type>:exists}, :$fallback) {
        my $type = from-ast($dict<Type>);
        my $subtype = from-ast($dict<Subtype> // $dict<S>)
	    unless $type eq 'Border';

        $.find-delegate( $type, $subtype, :$fallback );
    }

    #| Reverse lookup for classes when /Subtype is required but /Type is optional
    multi method delegate(Hash :$dict where {.<Subtype>:exists }, :$fallback) {
	my $subtype = from-ast $dict<Subtype>;

	my $type = do given $subtype {
	    # See [PDF 1.7 - TABLE 8.20 Annotation types]
	    when 'Text' | 'Link' | 'FreeText' | 'Line' | 'Square' | 'Circle'
		| 'Polygon' | 'PolyLine' | 'Highlight' |' Underline' | 'Squiggly'
		| 'StrikeOut' | 'Stamp' | 'Caret' | 'Ink' | 'Popup' | 'FileAttachment'
		| 'Sound' | 'Movie' | 'Widget' | 'Screen' | 'PrinterMark' | 'TrapNet'
		| 'Watermark' | '3D' { 'Annot' }
	    when 'PS' | 'Image' | 'Form'  { 'XObject' }
	    default { Nil }
	};

	if $type {
	    $.find-delegate($type, $subtype);
	}
	else {
	    note "unhandled subtype: PDF::Doc::Type::*::{$subtype}";
	    $fallback;
	}
    }

    #| Reverse lookup for classes when /Subtype is required but /Type is optional
    multi method delegate(Hash :$dict where {.<S>:exists && .<S> ~~ 'GTS_PDFX' },) {
	    $.find-delegate('OutputIntent', 'GTS_PDFX');
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
	3 <= $a.elems <= 5 && do {
	    my $t = from-ast $a[0];
	    $t ~~  PDF::DAO::Name && do given $t {
		when 'Indexed'    { my $hival = from-ast($a[2]); $hival ~~ UInt }
		when 'Separation' { from-ast($a[1]) ~~ PDF::DAO::Name }
		when 'DeviceN'    { from-ast($a[1]) ~~ Array }
		default {False}
	    }
	}
    }

    subset ColorSpace-Array of Array where ColorSpace-Array-CIE | ColorSpace-Array-Special;

    multi method delegate(ColorSpace-Array :$array!) {
	my $colorspace = from-ast $array[0];
	require ::('PDF::Doc::Type::ColorSpace')::($colorspace);
	::('PDF::Doc::Type::ColorSpace')::($colorspace);
    }

    multi method delegate(:$fallback!) is default {
	$fallback;
    }

}
