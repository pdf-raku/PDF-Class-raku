use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::Object::Inheritance;
use PDF::DOM::Type;
use PDF::DOM::Contents;
use PDF::DOM::Resources;
use PDF::DOM::PageSizes;

# /Type /Page - describes a single PDF page

class PDF::DOM::Type::Page
    is PDF::Object::Dict
    does PDF::Object::Inheritance
    does PDF::DOM::Type
    does PDF::DOM::Contents
    does PDF::DOM::Resources
    does PDF::DOM::PageSizes {

    use PDF::Object::Tie;

    use PDF::DOM::Type::XObject::Form;
    use PDF::DOM::Op :OpNames;

    has Hash $!Parent is entry;
    has Array $!MediaBox is entry;
    has Array $!Annots is entry;

    #| contents may either be a stream on an array of streams
    method contents {
        given $.Contents {
            when !.defined { [] }
            when Array     { $_ }
            when Hash      { [$_] }
            default { die "unexpected page content: {.perl}" }
        }
    }

    #| produce an XObject form for this page
    method to-xobject() {

        my %dict = (Resources => self.find-prop('Resources').clone,
                    BBox => self.find-prop('MediaBox').clone);

        my $xobject = PDF::DOM::Type::XObject::Form.new(:%dict);
        $xobject.pre-gfx.ops(self.pre-gfx.ops);
        $xobject.gfx.ops(self.gfx.ops);

        my Array $contents = $.contents;
        $xobject.edit-stream( :append([~] $contents.map({.decoded})) );
        if +$contents {
            # inherit compression from the first stream segment
            for $contents[0] {
                $xobject<Filter> = .<Filter>.clone
                    if .<Filter>:exists;
                $xobject<DecodeParms> = .<DecodeParms>.clone
                    if .<DecodeParms>:exists;
            }
        }

        $xobject;
    }

    method cb-finish {

        if $!pre-gfx.ops || $!gfx.ops {

            if $!pre-gfx.ops || $!gfx.ops {
                # handle new content.
                my @contents = @$.contents;
                if +@contents {
		    # dont trust existing content. wrap it in q ... Q
                    $!pre-gfx.ops.push: OpNames::Save;
                    $!gfx.ops.unshift: OpNames::Restore;
                }

                @contents.unshift: PDF::Object::Stream.new( :decoded( $!pre-gfx.content ~ "\n") )
                    if $!pre-gfx.ops;

                @contents.push: PDF::Object::Stream.new( :decoded("\n" ~ $!gfx.content ) )
                    if $!gfx.ops;

		$!pre-gfx.ops = ();
		$!gfx.ops = ();
                self<Contents> = @contents == 1 
		    ?? @contents[0]
		    !! @contents.item;
            }
        }
    }

}

