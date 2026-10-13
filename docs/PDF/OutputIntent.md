[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/Type /OutputIntent

### has PDF::COS::TextString $.OutputCondition

(Optional) A text string concisely identifying the intended output device or production condition in human-readable form

### has PDF::COS::TextString $.OutputConditionIdentifier

(Required)  A text string identifying the intended output device or production condition in human- or machine-readable form.

### has PDF::COS::TextString $.RegistryName

(Optional) A text string (conventionally a uniform resource identifier, or URI) identifying the registry in which the condition designated by OutputConditionIdentifier is defined

### has PDF::COS::TextString $.Info

(Required if OutputConditionIdentifier does not specify a standard production condition; optional otherwise) A human-readable text string containing additional information or comments about the intended target device or production condition

### has PDF::ICCProfile $.DestOutputProfile

(Required if OutputConditionIdentifier does not specify a standard production condition; optional otherwise) An ICC profile stream defining the transformation from the PDF document’s source colors to output device colorants.

### has PDF::COS::Dict $.DestOutputProfileRef

(Optional; PDF 2.0) A dictionary containing information about one or more referenced ICC profiles.

### has PDF::COS::Dict $.MixingHints

(Optional, PDF 2.0) A DeviceN Mixing Hints dictionary which does not contain a DotGain key.

### has PDF::COS::Dict $.SpectralData

(Optional, PDF 2.0) A dictionary where each key represents a colourant name as defined in 8.6.6.4, "Separation colour spaces" and where the value of each key shall be a stream whose contents represents CxF/X-4 spot colour characterisation data that conform to ISO 17972-4.

