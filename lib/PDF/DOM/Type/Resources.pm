use v6;

use PDF::DAO::Tie::Hash;

role PDF::DOM::Type::Resources
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::DAO::Stream;

    my role ResourceEntry {
	has Str $.key is rw;
    }

    # See [pDF 1.7 TABLE 3.30 Entries in a resource dictionary]

    has %.ExtGState  is entry;  #| (Optional) A dictionary that maps resource names to graphics state parameter dictionaries

    use PDF::DOM::Type::ColorSpace;
    my subset NameOrColorSpace of PDF::DAO where PDF::DAO::Name | PDF::DOM::Type::ColorSpace;
    has NameOrColorSpace %.ColorSpace is entry;  #| (Optional) A dictionary that maps each resource name to either the name of a device-dependent color space or an array describing a color space

    has %.Pattern    is entry;  #| (Optional) A dictionary that maps resource names to pattern objects

    has %.Shading    is entry;  #| (Optional; PDF 1.3) A dictionary that maps resource names to shading dictionaries

    has PDF::DAO::Stream %.XObject    is entry;  #| (Optional) A dictionary that maps resource names to external objects

    has Hash %.Font       is entry;  #| (Optional) A dictionary that maps resource names to font dictionaries
    has PDF::DAO::Name @.ProcSet    is entry;  #| (Optional) An array of predefined procedure set names
    has Hash %.Properties is entry;  #|  (Optional; PDF 1.2) A dictionary that maps resource names to property list dictionaries for marked content

    method !base-name( PDF::DAO $object ) is default {
        my Str $type = $object.?type
            // die "not a resource object: {$object.WHAT}";

        do given $type {
	    when 'ColorSpace' {'CS'}
            when 'ExtGState'  {'GS'}
            when 'Font'       {'F'}
            when 'Pattern'    {'Pt'}
	    when 'Shading'    {'Sh'}
            when 'XObject' {
                given $object.Subtype {
                    when 'Form'  {'Fm'}
                    when 'Image' {'Im'}
		    default { warn "unknown XObject subtype: $_"; 'Obj' }
		}
            }
            default { warn "unknown object type: $_"; 'Obj' }
        }
    }

    method !find-resource( &match, Str :$type! ) {
        my $entry;

        if my $resources = self{$type} {

            for $resources.keys {
                my $resource = $resources{$_};
                if &match($resource) {
                    $entry = $resource but ResourceEntry;
                    $entry.key = $_;
                    last;
                }
            }
        }

        $entry;
    }

    #| ensure that the object is registered as a page resource. Return a unique
    #| name for it.
    method !register-resource(PDF::DAO $object,
                             Str :$base-name = self!base-name($object),
                             :$type = $object.?type) {

	die "unable to register this resource - uknown type"
	    unless $type.defined;

        my Str $key = (1..*).map({$base-name ~ $_}).first({ self{$type}{$_}:!exists });
        self{$type}{$key} = $object;

        my $entry = $object but ResourceEntry;
        $entry.key = $key;
        $entry;
    }

    method core-font(|c) {
	use PDF::DOM::Type::Font;
	use PDF::DOM::Util::Font;

        my $core-font = PDF::DOM::Util::Font::core-font( |c );
        self!find-resource(sub ($_){.isa(PDF::DOM::Type::Font) && .font-obj === $core-font}, :type<Font>)
            // do {
                my %params = $core-font.to-dom('Font');
                my $new-obj = PDF::DAO.coerce( |%params );
                self!register-resource( $new-obj );
        };
    }

    method resource(PDF::DAO $object, Bool :$eqv=False ) {
        my Str $type = $object.?type
            // die "not a resource object: {$object.WHAT}";

	my &match = $eqv
	    ?? sub ($_){$_ eqv $object}
	    !! sub ($_){$_ === $object};
        self!find-resource(&match, :$type)
            // self!register-resource( $object );
    }

    method resource-entry(Str $type!, Str $key!) {
        return unless
            (self{$type}:exists)
            && (self{$type}{$key}:exists);

        my $object = self{$type}{$key};

        my $entry = $object but ResourceEntry;
        $entry.key = $key;
        $entry;
    }

}

