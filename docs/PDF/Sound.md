[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Numeric $.R

The sampling rate, in samples per second.

### has UInt $.C

The number of sound channels. Default value: 1.

### has UInt $.B

The number of bits per sample value per channel. Default value: 8.

### has PDF::Sound::EncodingName $.E

(Optional) The encoding format for the sample data:

### has PDF::COS::Name $.CO

The sound compression format used on the sample data. (This is separate from any stream compression specified by the sound object’s Filterentry; see Table 5 and 7.4, “Filters.”) If this entry is absent, sound compression is not used; the data contains sampled waveforms that is played at R samples per second per channel.

### has PDF::COS::Name $.CP

Optional parameters specific to the sound compression format used.

