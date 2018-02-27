use v6;

use PDF::DAO::Tie::Hash;

role PDF::Mask
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::DAO::Stream;
    #| /Type entry is optional, but should be /Mask when present
    my subset Name-Mask of PDF::DAO::Name where 'Mask';
    has Name-Mask $.Type is entry;
    method type {'Mask'}

    has PDF::DAO::Name $.S is entry(:required);   #| (Required) A subtype specifying the method to be used in deriving the mask values from the transparency group specified by the G entry:
        #| - Alpha: The group’s computed alpha shall be used, disregarding its colour.
        #| - Luminosity The group’s computed colour shall be converted to a single-component luminosity value (see
    has PDF::DAO::Stream $.G is entry(:required); #| (Required) A transparency group XObject to be used as the source of alpha or colour values for deriving the mask. If the subtype S is Luminosity, the group attributes dictionary shall contain a CS entry defining the colour space in which the compositing computation is to be performed.
    has Numeric @.BC is entry; #| An array of component values specifying the colour to be used as the backdrop against which to composite the transparency group XObject G. This entry shall be consulted only if the subtype S is Luminosity. The array shall consist of n numbers, where n is the number of components in the colour space specified by the CS entry in the group attributes dictionary
    #| Default value: the colour space’s initial value, representing black.
    use PDF::Function;
    my subset FunctionOrIdentity where PDF::Function|'Identity';
    has FunctionOrIdentity $.TR is entry;                 #| A function object specifying the transfer function to be used in deriving the mask values. The function shall accept one input, the computed group alpha or luminosity (depending on the value of the subtype S), and shall return one output, the resulting mask value. The input shall be in the range 0.0 to 1.0. The computed output shall be in the range 0.0 to 1.0; if it falls outside this range, it shall be forced to the nearest valid value. The name Identity may be specified in place of a function object to designate the identity
    #| function. Default value: Identity.

}
