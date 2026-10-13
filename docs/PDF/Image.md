[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has Numeric $.Width

(Required) The width of the image, in samples.

### has Numeric $.Height

(Required) The height of the image, in samples.

### has PDF::Class::Defs::ColorSpace $.ColorSpace

(Required for images, except those that use the JPXDecode filter; not allowed for image masks) The color space in which image samples are specified; it can be any type of color space except Pattern.

### has UInt $.BitsPerComponent

(Required except for image masks and images that use the JPXDecode filter)The number of bits used to represent each color component.

### has PDF::COS::Name $.Intent

(Optional; PDF 1.1) The name of a color rendering intent to be used in rendering the image

### has Bool $.ImageMask

(Optional) A flag indicating whether the image is to be treated as an image mask. If this flag is true, the value of BitsPerComponent must be 1 and Mask and ColorSpace should not be specified;

### has PDF::Image::MaskLike $.Mask

(Optional except for image masks; not allowed for image masks; PDF 1.3) An image XObject defining an image mask to be applied to this image, or an array specifying a range of colours to be applied to it as a colour key mask. If ImageMask is true, this entry shall not be present.

### has Positional[Numeric] @.Decode

(Optional) An array of numbers describing how to map image samples into the range of values appropriate for the image’s color space

### has Bool $.Interpolate

(Optional) A flag indicating whether image interpolation is to be performed

### has PDF::Image::SoftMask $.SMask

(Optional; PDF 1.4) A subsidiary image XObject defining a soft-mask image

### has PDF::Image::SMaskInInt $.SMaskInData

(Optional for images that use the JPXDecode filter, meaningless otherwise; A code specifying how soft-mask information encoded with image samples should be used: 0: If present, encoded soft-mask image information should be ignored. 1: The image’s data stream includes encoded soft-mask values. An application can create a soft-mask image from the information to be used as a source of mask shape or mask opacity in the transparency imaging model. 2: The image’s data stream includes color channels that have been preblended with a background; the image data also includes an opacity channel. An application can create a soft-mask image with a Matte entry from the opacity channel information to be used as a source of mask shape or mask opacity in the transparency model. If this entry has a nonzero value, SMask should not be specified

### has PDF::COS::Name $.Name

(Required in PDF 1.0; optional otherwise) The name by which this image XObject is referenced in the XObject subdictionary of the current resource dictionary. Note: This entry is obsolescent and its use is no longer recommended.

### has UInt $.StructParent

(Required if the image is a structural content item; PDF 1.3) The integer key of the image’s entry in the structural parent tree

### has Str $.ID

(Optional; PDF 1.3; indirect reference preferred) The digital identifier of the image’s parent Web Capture content set

### has Hash $.OPI

(Optional; PDF 1.2) An OPI version dictionary for the image. If ImageMask is true, this entry is ignored.

### has PDF::Metadata::XML $.Metadata

(Optional; PDF 1.4) A metadata stream containing metadata for the image

### has PDF::Class::OptionalContent $.OC

(Optional; PDF 1.5) An optional content group or optional content membership dictionary

### has Positional[PDF::Filespec] @.AF

(Optional; PDF 2.0) An array of one or more file specification dictionaries dictionaries which denote the associated files for this image.

### has PDF::COS::Dict $.Measure

(Optional; PDF 2.0) A measure dictionary that specifies the scale and units which apply to the image.

### has PDF::COS::Dict $.PtData

(Optional; PDF 2.0) A point data dictionary that specifies the extended geospatial data that apply to the image.

An image dictionary—that is, the dictionary portion of a stream representing an image XObject—may contain the entries listed in Table 89 in addition to the usual entries common to all streams (see Table 5). There are many relationships among these entries, and the current colour space may limit the choices for some of them. Attempting to use an image dictionary whose entries are inconsistent with each other or with the current colour space shall cause an error. The entries described here are appropriate for a base image—one that is an [PDF::XObject::Image](https://pdf-raku.github.io/PDF-Class-raku) invoked directly with the Do operator.

Some of the entries are not applicable to images used in other ways, such as for alternate images (see 8.9.5.4, "Alternate Images"), image masks (see 8.9.6, "Masked Images"), or thumbnail images (see 12.3.4, "Thumbnail Images"). Except as noted, such irrelevant entries are simply ignored by a conforming reader

