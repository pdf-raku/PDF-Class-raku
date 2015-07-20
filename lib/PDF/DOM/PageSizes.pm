use v6;

role PDF::DOM::PageSizes {

    subset BoxName of Str where 'media' | 'crop' | 'bleed' | 'trim' | 'art';
    method !bbox-name(BoxName $box) {
	{ :media<MediaBox>, :crop<CropBox>, :bleed<BleedBox>, :trim<TrimBox>, :art<ArtBox> }{$box}
    }
    method !get-prop(BoxName $box) {
	my $bbox = self!"bbox-name"($box);
        my $media-box = self.can('find-prop')
            ?? self.find-prop($bbox)
            !! self{$bbox};
    }

    multi method bbox(BoxName $box!, Numeric $lx!, Numeric $ly!, Numeric $ux!, Numeric $uy!
	--> Array) {
        self{ self!"bbox-name"($box) } = [$lx, $ly, $ux, $uy ]
    }

    multi method bbox(BoxName $box!, Numeric $ux!, Numeric $uy!
	--> Array) {
        self.media-box(0, 0, $ux, $uy)
    }

    multi method bbox('media' --> Array) {
	my $bbox = self!"get-prop"('media');
        $bbox // [0, 0, 612, 792];
    }

    multi method bbox('crop' --> Any) {
	my $bbox = self!"get-prop"('crop');
        $bbox // self.bbox('media');
    }

    multi method bbox(BoxName $box --> Any) is default {
	my $bbox = self!"get-prop"($box);
        $bbox // self.bbox('crop');
    }

    method media-box(*@args) { self.bbox('media', |@args) }
    method crop-box(*@args) { self.bbox('crop', |@args) }
    method bleed-box(*@args) { self.bbox('bleed', |@args) }
    method trim-box(*@args) { self.bbox('trim', |@args) }
    method art-box(*@args) { self.bbox('art', |@args) }

}
