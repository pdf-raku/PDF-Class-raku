use v6;

use PDF::DOM::Type::XObject;

#| XObjects
#| /Type XObject /Subtype /Image
#| See [PDF 1.7 Section 4.8 - Images ]
class PDF::DOM::Type::XObject::Image
    is PDF::DOM::Type::XObject {

    use PDF::Object::Tie;
    use PDF::Object::Stream;
    use PDF::Object::Array;
    use PDF::Object::Name;

    # See [PDF 1.7 TABLE 4.39 Additional entries specific to an image dictionary]
    has Numeric $!Width is entry(:required);      #| (Required) The width of the image, in samples.
    has Numeric $!Height is entry(:required);     #| (Required) The height of the image, in samples.
    subset NameOrArray of Any where PDF::Object::Name | PDF::Object::Array;
    has NameOrArray $!ColorSpace is entry(:required);         #| (Required for images, except those that use the JPXDecode filter; not allowed for image masks) The color space in which image samples are specified; it can be any type of color space except Pattern.
    has Int $!BitsPerComponent is entry;          #| (Required except for image masks and images that use the JPXDecode filter)The number of bits used to represent each color component.
    has PDF::Object::Name $!Intent is entry;      #| (Optional; PDF 1.1) The name of a color rendering intent to be used in rendering the image
    has Bool $!ImageMask is entry;                #| (Optional) A flag indicating whether the image is to be treated as an image mask. If this flag is true, the value of BitsPerComponent must be 1 and Mask and ColorSpace should not be specified;
    subset StreamOrArray of PDF::Object where PDF::Object::Stream | PDF::Object::Array;
    has StreamOrArray $!Mask is entry;            #| (Optional) A flag indicating whether the image is to be treated as an image mask (see Section 4.8.5, “Masked Images”). If this flag is true, the value of BitsPerComponent must be 1 and Mask and ColorSpace should not be specified;
    has Array $!Decode is entry;                  #| (Optional) An array of numbers describing how to map image samples into the range of values appropriate for the image’s color space
    has Bool $!Interpolate is entry;              #| (Optional) A flag indicating whether image interpolation is to be performed
    has Array $!Alternatives is entry;            #| An array of alternate image dictionaries for this image
    has PDF::Object::Stream $!SMask is entry;     #| (Optional; PDF 1.4) A subsidiary image XObject defining a soft-mask image
    subset SMaskInInt of Int where 0|1|2;
    has SMaskInInt $!SMaskInData is entry;        #| (Optional for images that use the JPXDecode filter, meaningless otherwise; A code specifying how soft-mask information encoded with image samples should be used:
                                                  #| 0: If present, encoded soft-mask image information should be ignored.
                                                  #| 1: The image’s data stream includes encoded soft-mask values. An application can create a soft-mask image from the information to be used as a source of mask shape or mask opacity in the transparency imaging model.
                                                  #| 2: The image’s data stream includes color channels that have been preblended with a background; the image data also includes an opacity channel. An application can create a soft-mask image with a Matte entry from the opacity channel information to be used as a source of mask shape or mask opacity in the transparency model.
                                                  #| If this entry has a nonzero value, SMask should not be specified
    has Int $!StructParent is entry;              #| (Required if the image is a structural content item; PDF 1.3) The integer key of the image’s entry in the structural parent tree
    has Str $!ID is entry;                        #| (Optional; PDF 1.3; indirect reference preferred) The digital identifier of the image’s parent Web Capture content set
    has Hash $!OPI is entry;                      #| Optional; PDF 1.2) An OPI version dictionary for the image. If ImageMask is true, this entry is ignored.
    has PDF::Object::Stream $!Metadata is entry;  #| (Optional; PDF 1.4) A metadata stream containing metadata for the image
    has Hash $!OC is entry;                       #| (Optional; PDF 1.5) An optional content group or optional content membership dictionary

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
        my Str $ext = $fh.path.extension;
        die ($ext
             ?? "can't yet handle files of type: $ext"
             !! "unable to determine image-type: {$fh.path.basename}");
    }

    method content(Bool :$inline = False) {
        nextsame unless $inline;   # normal case, constructing DOM object

        # for serialization to content stream ops: BI dict ID data EI
        use PDF::DOM::Op :OpNames;
        use PDF::Object::Util :to-ast-native;
        # serialize to content ops
        my %dict = to-ast-native(self).value.list;
        %dict<Type Subtype Length>:delete;
        [ (BeginImage) => [ :%dict ],
          (ImageData)  => [ :$.encoded ],
          (EndImage)   => [],
        ]
    }

}
