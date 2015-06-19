use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::Object::Inheritance;
use PDF::DOM::Type;
use PDF::DOM::Composition;
use PDF::DOM::Type::XObject::Form;

# /Type /Page - describes a single PDF page

class PDF::DOM::Type::Page
    is PDF::Object::Dict
    does PDF::Object::Inheritance
    does PDF::DOM::Type
    does PDF::DOM::Composition {

    method Parent is rw { self<Parent> }

    #| contents may either be a stream on an array of streams
    method contents {
        given $.Contents {
            when !.defined   { [] }
            when Array       { $_ }
            when Hash | Pair { [$_] }
            default { die "unexpected page content: {.perl}" }
        }
    }

    #| produce an XObject form for this page
    method to-xobject() {

        my %dict = (Resources => self.find-prop('Resources').clone,
                    BBox => self.find-prop('MediaBox').clone);

        my $xobject = PDF::DOM::Type::XObject::Form.new(:%dict);
        $xobject.pre-gfx.ops = self.pre-gfx.ops.clone;
        $xobject.gfx.ops = self.gfx.ops.clone;

        my $contents = $.contents;
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

            # wrap new content in save ... restore - for safety's sake
            for $!pre-gfx, $!gfx {
                if .defined && .ops {
                    .save(:prepend);
                    .restore;
                }
            }

            # also wrap any existing content in save ... restore
            my @contents = @$.contents;
            if +@contents {
                # wrap ex
                $!pre-gfx.save;
                $!gfx.restore(:prepend);
            }

            @contents.unshift: PDF::Object::Stream.new( :decoded( $!pre-gfx.content ~ "\n" ) )
                if $!pre-gfx.ops;

            @contents.push: PDF::Object::Stream.new( :decoded( "\n" ~ $!gfx.content ) )
                if $!gfx.ops;

            self<Contents> = @contents.item;
        }

    }

}

