use v6;

use PDF::Object;
use PDF::DOM::Type;
use PDF::DOM::Util::Font;
use PDF::DOM::Type::Font;

role PDF::DOM::Resources {

    method Resources is rw { self<Resources> }

    role ResourceEntry {
        has Str $.key is rw;
    }

    method core-font( *@arg, *%opt ) {
        my $core-font = PDF::DOM::Util::Font::core-font( |@arg, |%opt );
        my Pair $lookup = self!"find-resource"(sub ($_){.isa(PDF::DOM::Type::Font) && .font-obj === $core-font}, :type<Font>)
            // do {
                my %params = $core-font.to-dom('Font');
                my $new-obj = PDF::Object.compose( |%params );
                my Pair $new-entry = self!"register-resource"( $new-obj );
                $new-entry;
        };
        my $entry = $lookup.value but ResourceEntry;
        $entry.key = $lookup.key;
        $entry;
    }

    method resource(PDF::Object $object) {
        my $type = $object.?Type
            // die "not a resource object: {$object.WHAT}";

        my Pair $lookup = self!"find-resource"(sub ($_){$_ === $object}, :$type)
            //  self!"register-resource"( $object );

        my $entry = $lookup.value but ResourceEntry;
        $entry.key = $lookup.key;
        $entry;
    }

    method !find-resource( &match, Str :$type! ) {

        my $resources = self.can('find-prop')
            ?? self.find-prop('Resources')
            !! self.Resources;

       $resources // {};

        my $found;

        if $resources = $resources{$type} {

            for $resources.keys {
                my $resource = $resources{$_};
                if &match($resource) {
                    $found = $_ => $resource;
                    last;
                }
            }
        }

        $found;
    }

    method !base-name( PDF::DOM::Type $object ) {
        my $type = $object.?Type
            // die "not a resource object: {$object.WHAT}";

        do given $type {
            when 'Font' {'F'}
            when 'Pattern' {'P'}
            when 'XObject' {
                $object.Subtype eq 'Form'
                    ?? 'Fm'
                    !! 'Im';
            }
            default { 'Obj' }
        }
    }

    #| ensure that the object is registered as a page resource. Return a unique
    #| name for it.
    method !register-resource(PDF::Object $object,
                             Str :$base-name = self!"base-name"($object),
                             :$type = $object.Type
        --> Pair ) {
        my $id = $object.id;
        my $resources = self.can('find-prop')
            ?? self.find-prop('Resources')
            !! self.Resources;

        $resources //= do {
            self.Resources = {};
            self.Resources
        };

        $resources{$type} //= {};

        my $name = (1..*).map({$base-name ~ $_}).first({ $resources{$type}{$_}:!exists });
        $resources{$type}{$name} = $object;

        $name => $object;
    }

}
