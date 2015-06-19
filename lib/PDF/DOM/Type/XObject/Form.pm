use v6;

use PDF::DOM::Type::XObject;
use PDF::DOM::Composition;
use PDF::Writer;

class PDF::DOM::Type::XObject::Form
    is PDF::DOM::Type::XObject
    does PDF::DOM::Composition {

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
            my $content = self.decoded;
            if $content.defined && $content.chars
                && ($content !~~ m:s/^ 'q' /  || $content !~~ m:s/ 'Q' ^/) {
                $!pre-gfx.save;
                $!gfx.restore(:prepend);
            }

            my $writer = PDF::Writer.new;

            my $prepend = $!pre-gfx.ops
                ?? $writer.write(:content($!pre-gfx.ops)) ~ "\n"
                !! '';

            my $append = $!gfx.ops
                ?? "\n" ~ $writer.write(:content($!gfx.ops))
                !! '';

            self.edit-stream(:$prepend, :$append)
                if $prepend.chars || $append.chars;
        }
    }
}
