[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



Signature Field Lock Dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, must be SigFieldLock for a signature field lock dictionary

### has PDF::Field::Signature::LockDict::ActionSet $.Actions

(Required) A name which, in conjunction with Fields, indicates the set of fields that should be locked

### has Positional[PDF::COS::TextString] @.Fields

(Required if the value of Action is Include or Exclude) An array of text strings containing field names.

### has PDF::Field::Signature::LockDict $.Lock

(Optional; must be an indirect reference; PDF 1.5) A signature field lock dictionary that specifies a set of form fields to be locked when this signature field is signed. Table 8.82lists the entries in this dictionary.



Signature Field Seed Value dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, must be SV for a seed value dictionary.

### has PDF::COS::Name $.Filter

(Optional) The signature handler to be used to sign the signature field. Beginning with PDF 1.7, if Filter is specified and the Ff entry indicates this entry is a required constraint, then the signature handler specified by this entry must be used when signing; otherwise, signing must not take place. If Ff indicates that this is an optional constraint, this handler should be used if it is available. If it is not available, a different handler can be used instead.

### has Positional[PDF::COS::Name] @.SubFilter

first name in the array that matches an encoding supported by the signature handler should be the encoding that is actually used for signing. If SubFilter is specified and the Ff entry indicates that this entry is a required constraint, then the first matching encodings must be used when signing; otherwise, signing must not take place. If Ff indicates that this is an optional constraint, then the first matching encoding should be used if it is available. If it is not available, a different encoding can be used.

### has Positional[PDF::Field::Signature::SeedValueDict::DigestMethodName] @.DigestMethod

(Optional; PDF 1.7) An array of names indicating acceptable digest algorithms to use while signing. The valid values are SHA1, SHA256, SHA384, SHA512 and RIPEMD160. The default value is implementation-specific. Note: This property is only applicable if the digital credential signing contains RSA public/private keys. If it contains DSA public/ private key, the digest algorithm is always SHA1 and this attribute is ignored.

### has Numeric $.V

(Optional) The minimum required capability of the signature field seed value dictionary parser. A value of 1 specifies that the parser must be able to recognize all seed value dictionary entries specified in PDF 1.5. A value of 2 specifies that it must be able to recognize all seed value dictionary entries specified in PDF 1.7 and earlier.



Certification Seed Value dictionary

### has <anon> $.Type

(Optional) The type of PDF object that this dictionary describes; if present, shall be SVCert for a certificate seed value dictionary.

### has UInt $.Ff

[integer] (Optional) A set of bit flags specifying the interpretation of specific entries in this dictionary. A value of 1 for the flag means that a signer shall be required to use only the specified values for the entry. A value of 0 means that other values are permissible. Bit positions are 1 (Subject); 2 (Issuer); 3 (OID); 4 (SubjectDN); 5 (Reserved); 6 (KeyUsage); 7 (URL). Default value: 0.

### has Positional[Str] @.Subject

[array] (Optional) An array of byte strings containing DER-encoded X.509v3 certificates that are acceptable for signing. X.509v3 certificates are described in RFC 3280, Internet X.509 Public Key Infrastructure, Certificate and Certificate Revocation List (CRL) Profile (see the Link Bibliography ). The value of the corresponding flag in the Ff entry indicates whether this is a required constraint.

### has Positional[Str] @.SubjectDN

[array of dictionaries] (Optional; PDF 1.7) An array of dictionaries, each specifying a Subject Distinguished Name (DN) that shall be present within the certificate for it to be acceptable for signing. The certificate ultimately used for the digital signature shall contain all the attributes specified in each of the dictionaries in this array. (PDF keys and values are mapped to certificate attributes and values.) The certificate is not constrained to use only attribute entries from these dictionaries but may contain additional attributes.The Subject Distinguished Name is described in RFC 3280 (see the Link Bibliography ). The key can be any legal attribute identifier (OID). Attribute names shall contain characters in the set a-z A-Z 0-9 and PERIOD. Certificate attribute names are used as key names in the dictionaries in this array. Values of the attributes are used as values of the keys. Values shall be text strings.

### has Positional[PDF::Class::Defs::AsciiStr] @.KeyUsage

[array of ASCII strings] (Optional; PDF 1.7) An array of ASCII strings, where each string specifies an acceptable key-usage extension that shall be present in the signing certificate. Multiple strings specify a range of acceptable key-usage extensions. The key-usage extension is described in RFC 3280.

### has Positional[Str] @.Issuer

[array] (Optional) An array of byte strings containing DER-encoded X.509v3 certificates of acceptable issuers. If the signer’s certificate refers to any of the specified issuers (either directly or indirectly), the certificate shall be considered acceptable for signing. The value of the corresponding flag in the Ff entry indicates whether this is a required constraint. This array may contain self-signed certificates.

### has Positional[Str] @.OID

[array] (Optional) An array of byte strings that contain Object Identifiers (OIDs) of the certificate policies that shall be present in the signing certificate.

### has PDF::Class::Defs::AsciiStr $.URL

[ASCII string] (Optional) A URL, the use for which shall be defined by the URLTypeentry.

### has <anon> $.URLType

[Name] (Optional; PDF 1.7) A name indicating the usage of the URL entry. There are standard uses and there can be implementation-specific uses for this URL. The following value specifies a valid standard usage:

### has PDF::Field::Signature::SeedValueDict::CertificateSeedValueDict $.Cert

(Optional) A certificate seed value dictionary containing information about the certificate to be used when signing.

### has Positional[PDF::COS::TextString] @.Reasons

(Optional) An array of text strings that specifying possible reasons for signing a document. If specified, the reasons supplied in this entry replace those used by viewer applications. The Ff entry specifies whether one of the reasons in the array must be used in the signature.

### has PDF::Field::Signature::SeedValueDict::TimeStampUrl $.TimeStamp

(Optional; PDF 1.6) A time stamp dictionary containing two entries: URL: An ASCII string specifying the URL of a time-stamping server, providing a time stamp that is compliant with RFC 3161, Internet X.509 Public Key Infrastructure Time-Stamp Protocol (see the Bibliography). Ff: An integer whose value is 1 (the signature is required to have a time stamp) or 0 (the signature is not required to have a time stamp). Default value: 0.

### has Bool $.AddRevInfo

(Optional; PDF 1.7) A flag indicating whether revocation checking should be carried out. If AddRevInfo is true, the viewer application performs the following additional tasks when signing the signature field:

### has UInt $.Ff

(Optional) A set of bit flags specifying the interpretation of specific entries in this dictionary. A value of 1 for the flag indicates that the associated entry is a required constraint. A value of 0 indicates that the associated entry is an optional constraint. Bit positions are 1 (Filter); 2 (SubFilter); 3 (V); 4 (Reasons); 5 (LegalAttestation); 6(AddRevInfo); and 7(DigestMethod)

### has PDF::Field::Signature::SeedValueDict $.SV

(Optional; must be an indirect reference; PDF 1.5) A seed value dictionary (see Table 8.83) containing information that constrains the properties of a signature that is applied to this field.

