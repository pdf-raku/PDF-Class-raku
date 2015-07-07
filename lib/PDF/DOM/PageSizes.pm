use v6;

role PDF::DOM::PageSizes {

    multi method media-box(Numeric $lx!, Numeric $ly!, Numeric $ux!, Numeric $uy! ) {
        self<MediaBox> = [$lx, $ly, $ux, $uy ]
    }

    multi method media-box(Numeric $ux!, Numeric $uy! ) {
        self.media-box(0, 0, $ux, $uy)
    }

    multi method media-box() is default {
        self.?find-prop('MediaBox')
            // [0, 0, 612, 792];
    }

}
