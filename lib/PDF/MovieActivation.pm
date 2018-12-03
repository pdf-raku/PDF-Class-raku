use v6;
use PDF::COS::Tie::Hash;
role PDF::MovieActivation
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Name;

    # See [PDF 32000 Table 296 - Entries in a movie activitation dictionary]
    use ISO_32000::Movie_activation;
    also does ISO_32000::Movie_activation;

    has $.Start is entry; # (Optional) The starting time of the movie segment to be played. Movie time values is expressed in units of time based on a time scale, which defines the number of units per second. The default time scale is defined in the movie data. The starting time is nominally a non-negative 64-bit integer, specified as follows:
    # • If it is representable as an integer (subject to the implementation limit for integers, as described in Link Annex C ), it is specified as such.
    # • If it is not representable as an integer, it is specified as an 8-byte string representing a 64-bit twos-complement integer, most significant byte first.
    # • If it is expressed in a time scale different from that of the movie itself, it is represented as an array of two values: an integer or byte string denoting the starting time, followed by an integer specifying the time scale in units per second. If this entry is omitted, the movie is played from the beginning.
    has $.Duration is entry; # (Optional) The duration of the movie segment to be played, that is specified in the same form as Start. If this entry is omitted, the movie is played to the end.
    has Numeric $.Rate is entry(:default(1.0)); # (Optional) The initial speed at which to play the movie. If the value of this entry is negative, the movie is played backward with respect to Start and Duration. Default value: 1.0.
    has Numeric $.Volume is entry(:default(1.0)); # (Optional) The initial sound volume at which to play the movie, in the range −1.0 to 1.0. Higher values shall denote greater volume; negative values shall mute the sound. Default value: 1.0.
    has Bool $.ShowControls is entry(:!default); # (Optional) A flag specifying whether to display a movie controller bar while playing the movie. Default value: false.
    my subset Mode of PDF::COS::Name where 'Once'|'Open'|'Repeat'|'Palindrome';
    has Mode $.Mode is entry; # (Optional) The play mode for playing the movie:
    # Once - Play once and stop.
    # Open - Play and leave the movie controller bar open.
    # Repeat - Play repeatedly from beginning to end until stopped.
    # Palindrome - Play continuously forward and backward until stopped.
    # Default value: Once.
    has Bool $.Synchronous is entry(:!default); #  (Optional) A flag specifying whether to play the movie synchronously or asynchronously. If this value is true, the movie player shall retain control until the movie is completed or dismissed by the user. If the value is false, the player shall return control to the conforming reader immediately after starting the movie. Default value: false.
    has Numeric @FWScale is entry(:len(2)); # (Optional) The magnification (zoom) factor at which the movie is played. The presence of this entry implies that the movie is played in a floating window. If the entry is absent, the movie is played in the annotation rectangle.
    # The value of the entry is an array of two positive integers, [ numerator denominator ], denoting a rational magnification factor for the movie. The final window size, in pixels, is: (numerator ÷ denominator) × Aspect
    # where the value of Aspect is taken from the movie dictionary (see Link Table 295 ).
    has Numeric @FWPosition is entry(:len(2)); # (Optional) For floating play windows, the relative position of the window on the screen. The value is an array of two numbers [ horiz vert ] each in the range 0.0 to 1.0, denoting the relative horizontal and vertical position of the movie window with respect to the screen.
}
