use v6;

role PDF::DOM::PageSizes {

    my subset BoxName of Str where 'media' | 'crop' | 'bleed' | 'trim' | 'art';
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

    method get-page-size(Str $page-size-name) {
	#| source: http://www.gnu.org/software/gv/
	my constant PageSizes = { 
	    :letter[612,792],
	    :tabloid[792,1224],
	    :ledger[1224,792],
	    :legal[612,1008],
	    :statement[396,612],
	    :executive[540,720],
	    :a0[2384,3371],
	    :a1[1685,2384],
	    :a2[1190,1684],
	    :a3[842,1190],
	    :a4[595,842],
	    :a5[420,595],
	    :b4[729,1032],
	    :b5[516,729],
	    :folio[612,936],
	    :quarto[610,780],
	    '10x14' => [720,1008],
	};

	die "invalid page size: $page-size-name. Please choose from: {PageSizes.keys.sort,join(', ')}"
	    unless PageSizes{$page-size-name}:exists;

	my $page-size = PageSizes{$page-size-name};
	@(0, 0, $page-size[0], $page-size[1])
    }

    multi method bbox(Str $media-name!, Str $page-size-name! --> Array) {
	my @page-size =self.get-page-size($page-size-name);
	self.bbox($media-name, |@page-size);
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
