use v6;

role PDF::Destination {

    # See:
    # - [PDF 32000 Table 149 - Destination syntax]
    # - [PDF 32000-2 Table 151 - Destination syntax]
    use PDF::COS::Tie::Array;
    also does PDF::COS::Tie::Array;

    my subset NumNull where Numeric|!.defined;  #| UInt value or null

    my enum Fit is export(:Fit) «
        :FitXYZoom<XYZ>     :FitWindow<Fit>
        :FitHoriz<FitH>     :FitVert<FitV>
        :FitRect<FitR>      :FitBox<FitB>
        :FitBoxHoriz<FitBH> :FitBoxVert<FitBV>
        »;

    use PDF::COS::Tie;
    use PDF::COS::Array;
    use PDF::COS::ByteString;
    use PDF::COS::Name;
    use PDF::COS::Tie::Hash;

    my subset PageLike of Hash where { .<Type> ~~ 'Page' }; # autoloaded PDF::Page
    my subset StructLike of Hash where { .<S>:exists };     # struct elem
    my subset PageRef where PageLike|UInt|Pair;
    my subset Dest where PageLike|StructLike|UInt|Pair;

    has PageRef $.page is index(0);
    has PDF::COS::Name $.fit is index(1);
    method is-page-ref { self[0] ~~ PageLike }

    multi sub is-dest-like(Dest $dest, 'XYZ', NumNull $left?,
                           NumNull $top?, NumNull $zoom?)          { True }
    multi sub is-dest-like(Dest $dest,)                         { True }
    multi sub is-dest-like(Dest $dest, 'Fit')                   { True }
    multi sub is-dest-like(Dest $dest, 'FitH', NumNull $top?)   { True }
    multi sub is-dest-like(Dest $dest, 'FitV', NumNull $left?)  { True }
    multi sub is-dest-like(Dest $dest, 'FitR', Numeric $left,
                           Numeric $bottom, Numeric $right,
                           Numeric $top )                          { True }
    multi sub is-dest-like(Dest $dest, 'FitB')                  { True }
    multi sub is-dest-like(Dest $dest, 'FitBH', NumNull $top?)  { True }
    multi sub is-dest-like(Dest $dest, 'FitBV', NumNull $left?) { True }
    multi sub is-dest-like(|c) { False }

    my subset ExplicitDestLike of List where is-dest-like(|$_);
    # Explicit or named destination
    my subset DestinationLike is export(:DestinationLike) where ExplicitDestLike|Str;

    method delegate-destination(ExplicitDestLike $_) {
        PDF::Destination[ .[1] ];
    }

    method !dest(List $dest) {
        my $role = $.delegate-destination($dest);
        $role.COERCE: $dest;
    }

    #| constructs a new PDF::Destination array object
    sub fit(Fit $f) { $f.value }
    multi method construct(FitWindow,  Dest :$dest!, )                { self!dest: [$dest, fit(FitWindow), ] }
    multi method construct(FitHoriz,   Dest :$dest!, Numeric :$top )  { self!dest: [$dest, fit(FitHoriz),    $top ] }
    multi method construct(FitVert,    Dest :$dest!, Numeric :$left ) { self!dest: [$dest, fit(FitVert),     $left ] }
    multi method construct(FitBox,     Dest :$dest!, )                { self!dest: [$dest, fit(FitBox),      ] }
    multi method construct(FitBoxHoriz,Dest :$dest!, Numeric :$top )  { self!dest: [$dest, fit(FitBoxHoriz), $top] }
    multi method construct(FitBoxVert, Dest :$dest!, Numeric :$left ) { self!dest: [$dest, fit(FitBoxVert),  $left] }

    multi method construct(FitXYZoom,  Dest :$dest!, Numeric :$left,
                           Numeric :$top, Numeric :$zoom )         { self!dest: [$dest, fit(FitXYZoom), $left, $top, $zoom ] }

    multi method construct(FitRect,    Dest :$dest!,
                           Numeric :$left!,   Numeric :$bottom!,
                           Numeric :$right!,  Numeric :$top!, )    { self!dest: [$dest, fit(FitRect), $left,
                                                                                                      $bottom, $right, $top] }

    multi method construct(Dest :$dest!, )                         { self!dest: [$dest, fit(FitWindow), ] }
    multi method construct(Str:D $fit, PageRef :$page!, *%c) { self.construct: $fit, :dest($page), |%c }
    multi method construct(PageRef :$page!, )                      { self!dest: [$page, fit(FitWindow), ] }
    multi method construct(ExplicitDestLike $dest)                 { self.construct(|$dest) }
    multi method construct(*@args) {
        fail "unable to construct destination: {@args.raku}";
    }

    # Coercions for explicit and named destinations
    # a named destination may be either a byte-string or name object
    my subset DestRef is export(:DestRef) where PDF::Destination|PDF::COS::Name|PDF::COS::ByteString;
    my subset LocalDestRef of DestRef is export(:LocalDestRef) where $_ ~~ PDF::Destination && .[0] ~~ PageLike:D || $_ ~~ Str;
    my subset RemoteDestRef of DestRef is export(:RemoteDestRef) where $_ ~~ PDF::Destination && .[0] ~~ UInt:D || $_ ~~ Str;
    my subset StructDestRef of PDF::Destination where .[0] ~~ StructLike:D;
    proto sub coerce-dest($,$) is export(:coerce-dest) {*};

    # assume an array is an explicit destination
    multi sub coerce-dest(ExplicitDestLike $_ is rw, DestRef) {
        my $role = $?ROLE.delegate-destination($_);
        $role.COERCE: $_;
    }

    multi sub coerce-dest(Str $_ is rw, DestRef) {
        $_ = PDF::COS::Name.COERCE: $_;
    }

    multi sub coerce-dest($_ is rw, DestRef) is hidden-from-backtrace {
        warn "Unable to handle destination: {.raku}";
    }

    multi sub coerce-dest($_ is copy, DestRef) {
        .&coerce-dest(DestRef);
    }
    multi sub coerce-dest($_ is raw, StructDestRef) {
        coerce-dest($_, DestRef)
    }
    # DestNamed coercement also allows an intermediate dictionary with a /D entry
    my role DestDict is export(:DestDict) does PDF::COS::Tie::Hash {
        has DestRef $.D is entry(:required, :alias<destination>, :coerce(&coerce-dest));
        has StructDestRef $.SD is entry(:coerce(&coerce-dest)); # (Optional; PDF 2.0) The structure destination to jump to. If present, the structure destination takes precedence over destination in the D entry.
    }

    my subset DestNamed is export(:DestNamed) where DestDict|DestRef;
    multi sub coerce-dest(Hash $dict, DestNamed) {
        DestDict.COERCE($dict);
    }
    multi sub coerce-dest($_, DestNamed) {
        coerce-dest($_, DestRef);
    }

}

role PDF::Destination['XYZ']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.left is index(2);
    has Numeric $.top is index(3);
    has Numeric $.zoom is index(4);
}

role PDF::Destination['Fit']
    does PDF::Destination {
}

role PDF::Destination['FitH']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.top is index(2);
}

role PDF::Destination['FitV']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.left is index(2);
}

role PDF::Destination['FitR']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.left is index(2);
    has Numeric $.bottom is index(3);
    has Numeric $.right is index(4);
    has Numeric $.top is index(5);
}

role PDF::Destination['FitB']
    does PDF::Destination {
}

role PDF::Destination['FitBH']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.top is index(2);
}

role PDF::Destination['FitBV']
    does PDF::Destination {
    use PDF::COS::Tie;
    has Numeric $.left is index(2);
}


