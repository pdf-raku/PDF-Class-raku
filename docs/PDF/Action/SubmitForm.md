[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Action::SubmitForm
-----------------------------

/Action Subtype - URI

Description
===========

Table 236 – Additional entries specific to a submit-form action

Methods (Entries)
=================

class PDF::Filespec::FileRef $.F
--------------------------------

(Required) A URL file specification giving the uniform resource locator (URL) of the script at the Web server that will process the submission.



(Optional) An array identifying which fields to include in the submission or which to exclude, depending on the setting of the Include/Exclude flag in the Flags entry. Each element of the array is either an indirect reference to a field dictionary or (PDF 1.3) a text string representing the fully qualified name of a field. Elements of both kinds may be mixed in the same array.

If this entry is omitted, the Include/Exclude flag is ignored, and all fields in the document’s interactive form is submitted except those whose NoExport flag is set. Fields with no values may also be excluded, as dictated by the value of the IncludeNoValueFields flag.

class UInt $.Flags
------------------

(Optional; inheritable) A set of flags specifying various characteristics of the action (see Table 237). Default value: 0.

