use v6;

role PDF::DOM::PageBoxes {

	#| source: http://www.gnu.org/software/gv/
    my subset Box of Array;# where {.elems == 4}
    my Array enum PageSizes is export(:PageSizes) «
	    :Letter[0,0,612,792]
	    :Tabloid[0,0,792,1224]
	    :Ledger[0,0,1224,792]
	    :Legal[0,0,612,1008]
	    :Statement[0,0,396,612]
	    :Executive[0,0,540,720]
	    :A0[0,0,2384,3371]
	    :A1[0,0,1685,2384]
	    :A2[0,0,1190,1684]
	    :A3[0,0,842,1190]
	    :A4[0,0,595,842]
	    :A5[0,0,420,595]
	    :B4[0,0,729,1032]
	    :B5[0,0,516,729]
	    :Folio[0,0,612,936]
	    :Quarto[0,0,610,780]
	»;

    #| e.g. $.landscape(PagesSizes::A4)
    method to-landscape(Box $p --> Box) {
	[ $p[1], $p[0], $p[3], $p[2] ]
    }

    my subset BoxName of Str where 'media' | 'crop' | 'bleed' | 'trim' | 'art';

    method !bbox-name(BoxName $box) {
	{ :media<MediaBox>, :crop<CropBox>, :bleed<BleedBox>, :trim<TrimBox>, :art<ArtBox> }{$box}
    }

    method !get-prop(BoxName $box) is rw {
	my $bbox = self!bbox-name($box);
        self."$bbox"();
    }

    multi method bbox('media') is rw {
        self.MediaBox //= PageSizes::Letter;
	self.MediaBox
    }

    multi method bbox('crop') is rw {
	self.CropBox
	    // self.bbox('media');
    }

    multi method bbox(BoxName $box) is rw is default {
	self!"get-prop"($box)
	    // self.bbox('crop');
    }

    method media-box(|c) is rw { self.bbox('media', |c ) }
    method crop-box(|c)  is rw { self.bbox('crop',  |c ) }
    method bleed-box(|c) is rw { self.bbox('bleed', |c ) }
    method trim-box(|c)  is rw { self.bbox('trim',  |c) }
    method art-box(|c)   is rw { self.bbox('art',   |c) }

}
