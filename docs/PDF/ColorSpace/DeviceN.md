[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



DeviceN Process dictionary

### has PDF::Class::Defs::ColorSpace $.ColorSpace

(Required) A name or array identifying the process color space, which may be any device or CIE-based color space. If an ICCBased color space is specified, it must provide calibration information appropriate for the process color components specified in the names array of the DeviceN color space.

### has Positional[PDF::COS::Name] @.Components

(Required) An array of component names that correspond, in order, to the components of the process color space specified in ColorSpace. For example, an RGB color space must have three names corresponding to red, green, and blue. The names may be arbitrary (that is, not the same as the standard names for the color space components) and must match those specified in the names array of the DeviceN color space, even if all components are not present in the names array.



DeviceN Mixing Hints dictionary

### has Associative[Numeric] %.Solidities

(Optional) A dictionary specifying the solidity of inks to be used in blending calculations when used as an alternative to the tint transformation function. For each entry, the key is a colorant name, and the value is a number between 0.0 and 1.0. This dictionary need not contain entries for all colorants used in this color space; it may also include additional colorants not used by this color space. A value of 1.0 simulates an ink that completely covers the inks beneath; a value of 0.0 simulates a transparent ink that completely reveals the inks beneath. An entry with a key of Default specifies a value to be used by all components in the associated DeviceN color space for which a solidity value is not explicitly provided. If Default is not present, the default value for unspecified colorants is 0.0; applications may choose to use other values. If this entry is present, PrintingOrder must also be present.

### has Positional[PDF::COS::Name] @.PrintingOrder

(Required if Solidities is present) An array of colorant names, specifying the order in which inks are laid down. Each component in the names array of the DeviceN color space must appear in this array (although the order is unrelated to the order specified in the names array). This entry may also list colorants unused by this specific DeviceN instance.

### has Numeric $.DotGain

(Optional) A dictionary specifying the dot gain of inks to be used in blending calculations when used as an alternative to the tint transformation function. Dot gain (or loss) represents the amount by which a printer’s halftone dots change as the ink spreads and is absorbed by paper. For each entry, the key is a colorant name, and the value is a function that maps values in the range 0 to 1 to values in the range 0 to 1. The dictionary may list colorants unused by this specific DeviceN instance and need not list all colorants. An entry with a key of Default specifies a function to be used by all colorants for which a dot gain function is not explicitly specified. PDF consumer applications may ignore values in this dictionary when other sources of dot gain information are available, such as ICC profiles associated with the process color space or tint transformation functions associated with individual colorants.



DeviceN Color-space Attributes dictionary

### has PDF::ColorSpace::DeviceN::DeviceNDict::DeviceNSubtype $.Subtype

(Optional; PDF 1.6) A name specifying the preferred treatment for the color space. Possible values are DeviceN and NChannel. Default value: DeviceN. This dictionary provides information about the individual colorants that may be useful to some applications. In particular, the alternate color space and tint transformation function of a Separation color space describe the appearance of that colorant alone, whereas those of a DeviceN color space describe only the appearance of its colorants in combination. If Subtype is NChannel, this dictionary must have entries for all spot colorants in this color space. This dictionary may also include additional colorants not used by this color space.

### has Associative[PDF::ColorSpace::Separation] %.Colorants

(Required if Subtype is NChannel and the color space includes spot colorants; otherwise optional) A dictionary describing the individual colorants used in the DeviceN color space. For each entry in this dictionary, the key is a colorant name and the value is an array defining a Separation color space for that colorant. The key must match the colorant name given in that color space. This dictionary provides information about the individual colorants that may be useful to some applications. In particular, the alternate color space and tint transformation function of a Separation color space describe the appearance of that colorant alone, whereas those of a DeviceN color space describe only the appearance of its colorants in combination. If Subtype is NChannel, this dictionary must have entries for all spot colorants in this color space. This dictionary may also include additional colorants not used by this color space.

### has PDF::ColorSpace::DeviceN::DeviceNProcessDict $.Process

(Required if Subtype is NChannel and the color space includes components of a process color space, otherwise optional; PDF 1.6) A dictionary (see Table 4.22) that describes the process color space whose components are included in this color space.

### has PDF::ColorSpace::DeviceN::DeviceNMixingHints $.MixingHints

(Optional; PDF 1.6) A dictionary (see Table 4.23) that specifies optional attributes of the inks to be used in blending calculations when used as an alternative to the tint transformation function.

