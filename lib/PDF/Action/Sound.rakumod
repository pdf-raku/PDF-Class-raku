#| /Action Subtype - Sound
unit class PDF::Action::Sound;
use PDF::Action;
use PDF::COS::Dict;

also is PDF::COS::Dict;
also does PDF::Action;

use ISO_32000::Table_208-Additional_entries_specific_to_a_sound_action;
also does ISO_32000::Table_208-Additional_entries_specific_to_a_sound_action;

use PDF::COS;
use PDF::COS::Tie;
use PDF::Sound;

has PDF::Sound $.Sound is entry(:required);    # A sound object defining the sound that is played (see 13.3, “Sounds”)
my subset Volume of Numeric where -1.0 .. 1.0;
has Volume $.Volume is entry(:default(1.0));   # The volume at which to play the sound, in the range −1.0 to 1.0. Default value: 1.0.
has Bool $.Synchronous is entry(:!default);    # A flag specifying whether to play the sound synchronously or asynchronously. If this flag is true, the conforming reader retains control, allowing no further user interaction other than canceling the sound, until the sound has been completely played. Default value: false.
has Bool $.Repeat is entry(:!default);         # A flag specifying whether to repeat the sound indefinitely. If this entry is present, the Synchronous entry is ignored. Default value: false.
has Bool $.Mix is entry(:!default);            # A flag specifying whether to mix this sound with any other sound already playing. If this flag is false, any previously playing sound is stopped before starting this sound; this can be used to stop a repeating sound (see Repeat). Default value: false.
