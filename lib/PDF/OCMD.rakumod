use v6;

# /Type /OCMD - Optional Content Membership Dictionary
class PDF::OCMD {
    use PDF::COS::Dict;
    use PDF::Class::Type;

    also is PDF::COS::Dict;
    also does PDF::Class::Type;

    # use ISO_32000::Table_99-Entries_in_an_Optional_Content_Membership_Dictionary;
    # also does ISO_32000::Table_99-Entries_in_an_Optional_Content_Membership_Dictionary;

    use PDF::COS::Tie;
    use PDF::COS::Tie::Hash;
    use PDF::COS::Dict;
    use PDF::COS::Name;
    use PDF::COS::TextString;
    use PDF::OCG;

    has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'OCMD';

    has PDF::OCG @.OCGs is entry(:array-or-item); # (Optional) A dictionary or array of dictionaries specifying the optional content groups whose states shall determine the visibility of content controlled by this membership dictionary. Null values or references to deleted objects shall be ignored. If this entry is not present, is an empty array, or contains references only to null or deleted objects, the membership dictionary shall have no effect on the visibility of any content.
    has PDF::COS::Name $.P is entry(:alias<visibility-policy>, :default<AnyOn>) where /^[All|Any][Off|On]$/; # (Optional) A name specifying the visibility policy for content belonging to this membership dictionary. Valid values shall be:
    # AllOn visible only if all of the entries in OCGs are ON
    # AnyOn visible if any of the entries in OCGs are ON
    # AnyOff visible if any of the entries in OCGs are OFF
    # AllOff visible only if all of the entries in OCGs are OFF
    # Default value: AnyOn
    has @.VE is entry(:alias<visibility-expression>);  # (Optional; PDF 1.6) An array specifying a visibility expression, used to compute visibility of content based on a set of optional content groups
}
