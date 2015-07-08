use v6;

use PDF::DOM::Type::XObject;

class PDF::DOM::Type::XObject::Image
    is PDF::DOM::Type::XObject {

    has Numeric:_ $!Width; method Width { self.tie($!Width) };
    has Numeric:_ $!Height; method Height { self.tie($!Height) };
    has $!ColorSpace; method ColorSpace { self.tie($!ColorSpace) };
    has Int:_ $!BitsPerComponent; method BitsPerComponent { self.tie($!BitsPerComponent) };

    method open($spec! where Str | IO::Handle ) {
        my $img = self.new;
        $img.read($spec);
        $img;
    }

    multi method read(Str $path! ) {
        self.read( $path.IO.open( :r, :enc<latin-1> ) );
    }

    multi method read(IO::Handle $fh! where $fh.path.extension ~~ m:i/ jpe?g $/) {

        my Blob $buf;
        my Int ($bpc, $height, $width, $cs);
        my Bool $is-dct;

        $fh.seek(0,0);
        $buf = $fh.read(2);
        my @soi = $buf.unpack("CC");
        die "image doesn't have a JPEG header"
            unless @soi[0] == 0xFF and @soi[1] == 0xD8;

        loop {
            $buf = $fh.read(4);
            my Int ($ff, $mark, $len) = $buf.unpack("CCn");
            last if ( $ff != 0xFF);
            last if ( $mark == 0xDA || $mark == 0xD9);  # SOS/EOI
            last if ( $len < 2);
            last if ( $fh.eof);

            $buf = $fh.read($len-2);
            next if ($mark == 0xFE);
            next if ($mark >= 0xE0 && $mark <= 0xEF);
            if (($mark >= 0xC0) && ($mark <= 0xCF) && 
                ($mark != 0xC4) && ($mark != 0xC8) && ($mark != 0xCC)) {
                $is-dct = ?( $mark == 0xC0 | 0xC2);
                ($bpc, $height, $width, $cs) = $buf.unpack("CnnC");
                last;
            }
        }

        my Str $color-space = do given $cs {
            when 3 {'DeviceRGB'}
            when 4 {'DeviceCMYK'}
            when 1 {'DeviceGray'}
            default {warn "JPEG has unknown color-space: $_";
                     'DeviceGray'}
        }

        $fh.seek(0,0);
        self.encoded( $fh.slurp-rest );

        self<Width> = $width;
        self<Height> = $height;
        self<BitsPerComponent> = $bpc;
        self<ColorSpace> = :name($color-space);
        self<Filter> = :name<DCTDecode>
            if $is-dct;

        return self;
    }

    multi method read(IO::Handle $fh!) is default {
        my $ext = $fh.path.extension;
        die ($ext
             ?? "can't yet handle files of type: $ext"
             !! "unable to determine image-type: {$fh.path.basename}");
    }

    method content(Bool :$inline = False) {
        nextsame unless $inline;   # normal case, constructing DOM object

        # for serialization to content stream ops: BI dict ID data EI
        use PDF::DOM::Contents::Op :OpNames;
        use PDF::Object :to-ast-native;
        # serialize to content ops
        my %dict = to-ast-native(self).value.list;
        %dict<Type Subtype Length>:delete;
        [ (BeginImage) => [ :%dict ],
          (ImageData)  => [ :$.encoded ],
          (EndImage)   => [],
        ]
    }

}
