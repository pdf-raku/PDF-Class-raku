
#| /Type /OutputIntent
unit role PDF::OutputIntent;

use PDF::COS::Tie::Hash;
use PDF::Class::Type;

also does PDF::COS::Tie::Hash;
also does PDF::Class::Type::Subtyped;

use ISO_32000::Table_365-Entries_in_an_output_intent_dictionary;
also does ISO_32000::Table_365-Entries_in_an_output_intent_dictionary;

use ISO_32000_2::Table_401-Entries_in_an_output_intent_dictionary;
also does ISO_32000_2::Table_401-Entries_in_an_output_intent_dictionary;

use PDF::COS::Tie;
use PDF::COS::Dict;
use PDF::COS::Name;
use PDF::COS::TextString;
use PDF::COS::Stream;
use PDF::ICCProfile;

has PDF::COS::Name $.Type is entry(:alias<type>) where 'OutputIntent';
has PDF::COS::Name $.S is entry(:required, :alias<subtype>); # Required) The output intent subtype; shall be either one of GTS_PDFX, GTS_PDFA1, ISO_PDFE1 or a key defined by an ISO 32000 extension.

has PDF::COS::TextString $.OutputCondition is entry;                       # (Optional) A text string concisely identifying the intended output device or production condition in human-readable form
has PDF::COS::TextString $.OutputConditionIdentifier is entry(:required);  # (Required)  A text string identifying the intended output device or production condition in human- or machine-readable form.
has PDF::COS::TextString $.RegistryName is entry;                          # (Optional) A text string (conventionally a uniform resource identifier, or URI) identifying the registry in which the condition designated by OutputConditionIdentifier is defined
has PDF::COS::TextString $.Info is entry;                 # (Required if OutputConditionIdentifier does not specify a standard production condition; optional otherwise) A human-readable text string containing additional information or comments about the intended target device or production condition
has PDF::ICCProfile $.DestOutputProfile is entry;         # (Required if OutputConditionIdentifier does not specify a standard production condition; optional otherwise) An ICC profile stream defining the transformation from the PDF document’s source colors to output device colorants.
has PDF::COS::Dict $.DestOutputProfileRef is entry;       # (Optional; PDF 2.0) A dictionary containing information about one or more referenced ICC profiles.
has PDF::COS::Dict $.MixingHints is entry;                # (Optional, PDF 2.0) A DeviceN Mixing Hints dictionary which does not contain a DotGain key.
has PDF::COS::Dict $.SpectralData is entry;               # (Optional, PDF 2.0) A dictionary where each key represents a colourant name as defined in 8.6.6.4, "Separation colour spaces" and where the value of each key shall be a stream whose contents represents CxF/X-4 spot colour characterisation data that conform to ISO 17972-4.
