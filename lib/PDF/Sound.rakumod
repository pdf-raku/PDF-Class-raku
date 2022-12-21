use v6;

unit role PDF::Sound;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

## use ISO_32000::Table_294-Additional_entries_specific_to_a_sound_object;
## also does ISO_32000::Table_294-Additional_entries_specific_to_a_sound_object;

use PDF::COS::Tie;
use PDF::COS::Name;

my subset SoundName of PDF::COS::Name where 'Sound';
has SoundName $.Type is entry;

has Numeric $.R is entry(:alias<rate>, :required);     # The sampling rate, in samples per second.
has UInt $.C is entry(:alias<channels>, :default(1));  # The number of sound channels. Default value: 1.
has UInt $.B is entry(:alias<bits>, :default(8));      # The number of bits per sample value per channel. Default value: 8.

my subset EncodingName of PDF::COS::Name where 'Raw'|'Signed'|'muLaw'|'ALaw';
has EncodingName $.E is entry(:alias<encoding>, :default<Raw>); # (Optional) The encoding format for the sample data:
# Raw - Unspecified or unsigned values in the range 0 to 2B − 1
# Signed - Twos-complement values
# muLaw m-law–encoded samples
# ALaw A-law–encoded samples
# Default value: Raw.

has PDF::COS::Name $.CO is entry(:alias<compression-format>); # The sound compression format used on the sample data. (This is separate from any stream compression specified by the sound object’s Filterentry; see Table 5 and 7.4, “Filters.”) If this entry is absent, sound compression is not used; the data contains sampled waveforms that is played at R samples per second per channel.

has PDF::COS::Name $.CP is entry(:alias<compression-params>); # Optional parameters specific to the sound compression format used.

