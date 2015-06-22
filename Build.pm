use v6;

use Panda::Builder;
use Panda::Common;
use Font::AFM;

class Build is Panda::Builder {

    method !save-glyph(Str $glyph-name, $chr, $ord, Hash :$encoding, Hash :$glyphs) {

            $encoding{$glyph-name} //= $ord.chr
                if $encoding.defined;

            # $chr.ord isn't unique? use NFD as index
            $glyphs{$chr} //= $glyph-name
                if $glyphs.defined;
    }

    method !build-enc(IO::Path $encoding-path, Hash :$glyphs! is rw, Hash :$encodings! is rw) {
        my $encoding-io = $encoding-path;

        die "unable to load encodings: $encoding-path"
            unless $encoding-path ~~ :e;

        my %latin1-chars = %Font::AFM::ISOLatin1Encoding.invert;

        for $encoding-path.lines {
            next if /^ '#'/ || /^ $/;
            m:s/^$<char>=. $<glyph-name>=\w+ [ $<enc>=[\d+|'—'] ]** 4 $/
               or do {
                   warn "unable to parse encoding line: $_";
                   next;
               };

            my $glyph-name = ~ $<glyph-name>;
            my @enc = @<enc>.map( {
                .Str eq '—' ?? Mu !! :8(.Str);
            } );

            my $chr = $<char>.Str;

            for :mac(@enc[1]),
                :win(@enc[2]) {
                my ($scheme, $byte) = .kv;
                next unless $byte.defined;
                my $enc = $encodings{$scheme} //= {}
                my $dec = $glyphs{$scheme} //= {}
                self!"save-glyph"(:glyphs($dec), :encoding($enc), $glyph-name, $chr, $byte);

                if my $alternate-chr = %latin1-chars{$glyph-name} {
                    if $alternate-chr ne $chr {
                        self!"save-glyph"(:glyphs($dec), $glyph-name, $alternate-chr, $byte);
                    }
                }
            }
        }
    }

    method !write-enc(Hash :$glyphs!, Hash :$encodings!) {
        my $lib-dir = $*SPEC.catdir('lib', 'PDF', 'DOM' , 'Util', 'Font');
        mkdir( $lib-dir, 0o755);

        my $class-name = "PDF::DOM::Util::Font::Encodings";
        my $gen-path = $*SPEC.catfile($lib-dir, "Encodings.pm");
        my $*OUT = open( $gen-path, :w);

        print q:to"--CODE-GEN--";
        use v6;
        # Single Byte Font Encodings
        #
        # DO NOT EDIT!!!
        #
        # This file was auto-generated

        class PDF::DOM::Util::Font::Encodings {

        --CODE-GEN--

        for $glyphs.keys.sort -> $type {
            say "    #-- {$type.uc} encoding --#"; 
            say "    BEGIN our \${$type}-glyphs = {$glyphs{$type}.perl};";
            say "    BEGIN our \${$type}-encoding = {$encodings{$type}.perl};";
            say "";
        }

        say '}';
    }

   method build($where) {

        indir $where, {
            my $glyphs = {};
            my $encodings = {};
            self!"build-enc"("etc/encodings.txt".IO, :$glyphs, :$encodings);
            self!"write-enc"(:$glyphs, :$encodings);
        }
    }
}

# Build.pm can also be run standalone 
sub MAIN(:$indir = '.', :$glyphs-path, :$encodings-path ) {

    Build.new.build($indir);
}

