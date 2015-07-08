use v6;

use PDF::Object::Dict;
use PDF::Object::Stream;
use PDF::Object::Inheritance;
use PDF::DOM::Type;
use PDF::DOM::Contents;
use PDF::DOM::Resources;
use PDF::DOM::PageSizes;
use PDF::DOM::Type::XObject::Form;

# /Type /Page - describes a single PDF page

class PDF::DOM::Type::Page
    is PDF::Object::Dict
    does PDF::Object::Inheritance
    does PDF::DOM::Type
    does PDF::DOM::Contents
    does PDF::DOM::Resources
    does PDF::DOM::PageSizes {

    has Hash:_ $!Parent; method Parent { self.tie($!Parent) };
    has Array:_ $!MediaBox; method MediaBox { self.tie($!MediaBox) };
    has Array:_ $!Annots; method Annots { self.tie($!Annots) };

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
        $xobject.pre-gfx.ops(self.pre-gfx.ops);
        $xobject.gfx.ops(self.gfx.ops);

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

            my $new-content;
            # wrap new content in save ... restore - for safety's sake
            for $!pre-gfx, $!gfx {
                if .defined && .ops {
                    $new-content = True;
                    .save(:prepend);
                    .restore;
                }
            }

            if $new-content {
                # also wrap any existing content in save ... restore
                my @contents = @$.contents;
                if +@contents {
                    # wrap ex
                    $!pre-gfx.save;
                    $!gfx.restore(:prepend);
                }

                @contents.unshift: PDF::Object::Stream.new( :decoded( "BT\n" ~ $!pre-gfx.content ~ "\nET\n" ) )
                    if $!pre-gfx.ops;

                @contents.push: PDF::Object::Stream.new( :decoded( "\nBT\n" ~ $!gfx.content ~ "\nET" ) )
                    if $!gfx.ops;

                self<Contents> = @contents.item;
            }
        }
    }

}

