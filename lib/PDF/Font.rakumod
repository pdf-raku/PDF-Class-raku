use v6;

#| /Type /Font - Describes a font

class PDF::Font {
    use PDF::COS::Dict;
    use PDF::Content::Font;
    use PDF::Class::Type;

    also is PDF::COS::Dict;
    also does PDF::Content::Font;
    also does PDF::Class::Type::Subtyped;

    use PDF::COS::Tie;
    use PDF::COS::Name;

    has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Font';
    has PDF::COS::Name $.Subtype is entry(:required, :alias<subtype>);

}
