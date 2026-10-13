[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::Sound
------------------------

/Action Subtype - Sound

### has PDF::Sound $.Sound

A sound object defining the sound that is played (see 13.3, “Sounds”)

### has PDF::Action::Sound::Volume $.Volume

The volume at which to play the sound, in the range −1.0 to 1.0. Default value: 1.0.

### has Bool $.Synchronous

A flag specifying whether to play the sound synchronously or asynchronously. If this flag is true, the conforming reader retains control, allowing no further user interaction other than canceling the sound, until the sound has been completely played. Default value: false.

### has Bool $.Repeat

A flag specifying whether to repeat the sound indefinitely. If this entry is present, the Synchronous entry is ignored. Default value: false.

### has Bool $.Mix

A flag specifying whether to mix this sound with any other sound already playing. If this flag is false, any previously playing sound is stopped before starting this sound; this can be used to stop a repeating sound (see Repeat). Default value: false.

