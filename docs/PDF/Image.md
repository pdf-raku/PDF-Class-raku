[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Image::SMaskInInt $.SMaskInData
------------------------------------------

(Optional for images that use the JPXDecode filter, meaningless otherwise; A code specifying how soft-mask information encoded with image samples should be used: 0: If present, encoded soft-mask image information should be ignored. 1: The image’s data stream includes encoded soft-mask values. An application can create a soft-mask image from the information to be used as a source of mask shape or mask opacity in the transparency imaging model. 2: The image’s data stream includes color channels that have been preblended with a background; the image data also includes an opacity channel. An application can create a soft-mask image with a Matte entry from the opacity channel information to be used as a source of mask shape or mask opacity in the transparency model. If this entry has a nonzero value, SMask should not be specified

class PDF::COS::Name $.Name
---------------------------

(Required in PDF 1.0; optional otherwise) The name by which this image XObject is referenced in the XObject subdictionary of the current resource dictionary. Note: This entry is obsolescent and its use is no longer recommended.

An image dictionary—that is, the dictionary portion of a stream representing an image XObject—may contain the entries listed in Table 89 in addition to the usual entries common to all streams (see Table 5). There are many relationships among these entries, and the current colour space may limit the choices for some of them. Attempting to use an image dictionary whose entries are inconsistent with each other or with the current colour space shall cause an error. The entries described here are appropriate for a base image—one that is an [PDF::XObject::Image](https://pdf-raku.github.io/PDF-Class-raku) invoked directly with the Do operator.

Some of the entries are not applicable to images used in other ways, such as for alternate images (see 8.9.5.4, "Alternate Images"), image masks (see 8.9.6, "Masked Images"), or thumbnail images (see 12.3.4, "Thumbnail Images"). Except as noted, such irrelevant entries are simply ignored by a conforming reader

