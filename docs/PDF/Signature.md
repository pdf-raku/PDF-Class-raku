[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Signature::SigType $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be Sig for a signature dictionary.

### has PDF::COS::Name $.Filter

(Required; inheritable) The name of the preferred signature handler to use when validating this signature. If the Prop_Build entry is not present, it shall be also the name of the signature handler that was used to create the signature. If Prop_Build is present, it may be used to determine the name of the handler that created the signature (which is typically the same as Filter but is not needed to be). A conforming reader may substitute a different handler when verifying the signature, as long as it supports the specified SubFilter format. Example signature handlers are Adobe.PPKLite, Entrust.PPKEF, CICI.SignIt, and VeriSign.PPKVS.

### has PDF::COS::Name $.SubFilter

(Optional) A name that describes the encoding of the signature value and key information in the signature dictionary. A conforming reader may use any handler that supports this format to validate the signature.

### has PDF::COS::ByteString $.Contents

(Required) The signature value. When ByteRange is present, the value shall be a hexadecimal string representing the value of the byte range digest. For public-key signatures, Contents should be either a DER-encoded PKCS#1 binary data object or a DER-encoded PKCS#7 binary data object.

### has Positional[PDF::COS::ByteString] @.Cert

(Required when SubFilter is adbe.x509.rsa_sha1) An array of byte strings that shall represent the X.509 certificate chain used when signing and verifying signatures that use public-key cryptography, or a byte string if the chain has only one entry. The signing certificate shall appear first in the array; it shall be used to verify the signature value in Contents, and the other certificates shall be used to verify the authenticity of the signing certificate.

### has Positional[UInt] @.ByteRange

(Required for all signatures that are part of a signature field and usage rights signatures referenced from the UR3 entry in the permissions dictionary) An array of pairs of integers (starting byte offset, length in bytes) that shall describe the exact byte range for the digest calculation. Multiple discontiguous byte ranges shall be used to describe a digest that does not include the signature value (the Contents entry) itself.



Signature Reference Dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be SigRef for a signature reference dictionary.

### has PDF::Signature::SignatureReference::TransformMethod $.TransformMethod

The name of the transform method (see Section that shall guide the modification analysis that takes place when the signature is validated.

### has Mu $.Data

(Required when TransformMethod is FieldMDP) An indirect reference to the object in the document upon which the object modification analysis should be performed.

### has Hash $.TransformParams

(Optional) A dictionary specifying transform parameters (variable data) for the transform method specified by TransformMethod.

### has PDF::COS::Name $.DigestMethod

Optional; PDF 1.5 required) A name identifying the algorithm that shall be used when computing the digest. Valid values are MD5 and SHA1. Default value: MD5. For security reasons, MD5 should not be used.

### has Positional[PDF::Signature::SignatureReference] @!Reference

(Optional; PDF 1.5) An array of signature reference dictionaries.

### has Positional[Int] @.Changes

(Optional) An array of three integers that shall specify changes to the document that have been made between the previous signature and this signature: in this order, the number of pages altered, the number of fields altered, and the number of fields filled in. The ordering of signatures shall be determined by the value of ByteRange. Since each signature results in an incremental save, later signatures have a greater length value.

### has PDF::COS::TextString $.Name

(Optional) The name of the person or authority signing the document. This value should be used only when it is not possible to extract the name from the signature.

### has PDF::COS::DateString $.M

(Optional) The time of signing. Depending on the signature handler, this may be a normal unverified computer time or a time generated in a verifiable way from a secure time server. This value should be used only when the time of signing is not available in the signature.

### has PDF::COS::TextString $.Location

(Optional) The CPU host name or physical location of the signing.

### has PDF::COS::TextString $.Reason

(Optional) The reason for the signing, such as ( I agree ... ).

### has PDF::COS::TextString $.ContactInfo

(Optional) Information provided by the signer to enable a recipient to contact the signer to verify the signature.

### has UInt $.R

(Optional) The version of the signature handler that was used to create the signature. (PDF 1.5) This entry shall not be used, and the information shall be stored in the Prop_Build dictionary.

### has UInt $.V

(Optional; PDF 1.5) The version of the signature dictionary format. It corresponds to the usage of the signature dictionary in the context of the value of SubFilter. The value is 1 if the Reference dictionary shall be considered critical to the validation of the signature.

### has Hash $.Prop_Build

(Optional; PDF 1.5) A dictionary that may be used by a signature handler to record information that captures the state of the computer environment used for signing, such as the name of the handler used to create the signature, software build date, version, and operating system.

### has UInt $.Prop_AuthTime

(Optional; PDF 1.5) The number of seconds since the signer was last authenticated, used in claims of signature repudiation. It should be omitted if the value is unknown.

### has PDF::Signature::AuthType $.Prop_AuthType

(Optional; PDF 1.5) The method that shall be used to authenticate the signer, used in claims of signature repudiation. Valid values shall be PIN, Password, and Fingerprint.

