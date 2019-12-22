use v6;
use PDF::Content::Interface;

unit class PDF::Class::Interface
    ## todo: requires PDF::Content:ver<0.3.1+>, PDF::ver<0.3.8+>
    ## does PDF::Content::Interface
    ;
# a definition of the methods implemented by PDF::Class

method type {...}
method version {...}
