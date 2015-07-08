use v6;

role PDF::DOM::PageSizes {

    multi method media-box(Numeric $lx!, Numeric $ly!, Numeric $ux!, Numeric $uy! ) {
        self<MediaBox> = [$lx, $ly, $ux, $uy ]
    }

    multi method media-box(Numeric $ux!, Numeric $uy! ) {
        self.media-box(0, 0, $ux, $uy)
    }

    multi method media-box() is default {
        my $media-box = self.can('find-prop')
            ?? self.find-prop('MediaBox')
            !! self<MediaBox>;

        $media-box // [0, 0, 612, 792];
    }

}
