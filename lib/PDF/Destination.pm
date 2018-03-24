use v6;
use PDF::COS;
use PDF::COS::Tie;
use PDF::COS::Tie::Array;

my subset NumNull where { .does(Numeric) || !.defined };  #| UInt value or null

role PDF::Destination does PDF::COS::Tie::Array {
    has $.page is index(0);
    has $.type is index(1);
    # See [PDF 1.7 TABLE 8.2 Destination syntax]
    multi sub is-destination($page, 'XYZ', NumNull $left,
                             NumNull $top, NumNull $zoom)        { True }
    multi sub is-destination($page, 'Fit')                       { True }
    multi sub is-destination($page, 'FitH',  NumNull $top)       { True }
    multi sub is-destination($page, 'FitV',  NumNull $left)      { True }
    multi sub is-destination($page, 'FitR',  Numeric $left,
                             Numeric $bottom, Numeric $right,
                             Numeric $top )                      { True }
    multi sub is-destination($page, 'FitB')                      { True }
    multi sub is-destination($page, 'FitBH', NumNull $top)       { True }
    multi sub is-destination($page, 'FitBV', NumNull $left)      { True }
    multi sub is-destination(|c)                      is default { False }

    my subset DestinationArray of Array where is-destination(|$_);

    method delegate-destination(DestinationArray $_) {
        PDF::Destination[ .[1] ];
    }

}

role PDF::Destination['XYZ']
    does PDF::Destination {
    has Numeric $.left is index(2);
    has Numeric $.top is index(3);
    has Numeric $.zoom is index(4);
}

role PDF::Destination['Fit']
    does PDF::Destination {
}

role PDF::Destination['FitH']
    does PDF::Destination {
    has Numeric $.top is index(2);
}

role PDF::Destination['FitV']
    does PDF::Destination {
    has Numeric $.left is index(2);
}

role PDF::Destination['FitR']
    does PDF::Destination {
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
    has Numeric $.top is index(2);
}

role PDF::Destination['FitBV']
    does PDF::Destination {
    has Numeric $.left is index(2);
}

