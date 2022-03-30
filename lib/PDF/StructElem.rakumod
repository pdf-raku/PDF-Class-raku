use v6;

use PDF::COS::Tie::Hash;

#| an entry in the StructTree
#| See also PDF::StructTreeRoot

role PDF::StructElem
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;
    use PDF::Page;

    # use ISO_32000::Table_323-Entries_in_a_structure_element_dictionary;
    # also does ISO_32000::Table_323-Entries_in_a_structure_element_dictionary;

    has PDF::COS::Name $.Type is entry where 'StructElem'; # (Optional) The type of PDF object that this dictionary describes; if present, shall be StructElem for a structure element.

    has PDF::COS::Name $.S is entry(:required, :alias<tag>); # (Required) The structure type, a name object identifying the nature of the structure element and its role within the document, such as a chapter, paragraph, or footnote
    has Str $.ID is entry;    # (Optional) The element identifier, a byte string designating this structure element. The string shall be unique among all elements in the document’s structure hierarchy. The IDTree entry in the structure tree root defines the correspondence between element identifiers and the structure elements they denote.
    has PDF::Page $.Pg is entry(:indirect, :alias<page>); # (Optional; shall be an indirect reference) A page object representing a page on which some or all of the content items designated by the K entry shall be rendered.
    my subset ReferenceLike of Hash where .<Type> ~~ 'MCR'|'OBJR'; # autoloaded PDF::MCR, PDF::OBJR
    my subset StructElemLike of Hash where .<S>:exists;
    my subset StructRootLike of Hash where { .<Type> ~~ 'StructTreeRoot' }; # autoloaded PDF::StructTreeRoot
    my subset StructElemParent where StructRootLike|PDF::StructElem;
    my subset StructElemChild is export(:StructElemChild) where Any:U|UInt|PDF::StructElem|ReferenceLike;
    sub coerce-struct-kids($obj, StructElemChild) is export(:coerce-struct-kids) {
        # /K can be a single element or an array of elements
        if $obj ~~ List {
            for $obj.keys {
                coerce-child($_, StructElemChild)
                    with $obj[$_];
            }
        }
        else {
            coerce-child($obj, StructElemChild)
        }
        $obj;
    }

    multi sub coerce-parent(StructElemParent $obj, StructElemParent) { $obj }
    multi sub coerce-parent(StructElemLike $obj, StructElemParent) {
        PDF::StructElem.COERCE($obj);
    }
    multi sub coerce-parent($_, StructElemParent) {
        warn "Unable to coerce {.raku} to a PDF::StructElem.P (parent) element";
    }

    multi sub coerce-child(StructElemChild $obj, StructElemChild) { $obj }
    multi sub coerce-child(StructElemLike $obj, StructElemChild) {
        PDF::StructElem.COERCE($obj);
    }
    multi sub coerce-child($_, StructElemChild) {
        warn "Unable to coerce {.raku} to a PDF::StructElem.K (child) element";
    }

    has StructElemParent $.P is entry(:required, :alias<struct-parent>, :coerce(&coerce-parent)); # (Required; shall be an indirect reference) The structure element that is the immediate parent of this one in the structure hierarchy.
    has StructElemChild @.K is entry(:array-or-item, :alias<kids>, :coerce(&coerce-child));       # (Optional) The children of this structure element. The value of this entry may be one of the following objects or an array consisting of one or more of the following objects:
    # • A structure element dictionary denoting another structure element
    # • An integer marked-content identifier denoting a marked-content sequence
    # • A marked-content reference dictionary denoting a marked-content sequence
    # • An object reference dictionary denoting a PDF object
    # Each of these objects other than the first shall be considered to be a content item;
    # If the value of K is a dictionary containing no Type entry, it shall be assumed to be a structure element dictionary.
    my role Attributes is export(:Attributes) does PDF::COS::Tie::Hash {
        # use  ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;
        # also does ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries;
        has PDF::COS::Name $.O is entry(:alias<owner>);
        method set-attribute($key, $value) { self{$key} = $value }
        method Hash {
            my @keys = self.keys.grep: * ne 'O';
            my % = @keys.map: { $_ => self{$_} }
        }
    }
    my role UserProperties is export(:UserProperties) does Attributes {
        # use ISO_32000::Table_328-Additional_entries_in_an_attribute_object_dictionary_for_user_properties;
        # also does ISO_32000::Table_328-Additional_entries_in_an_attribute_object_dictionary_for_user_properties
        my role UserProperty does PDF::COS::Tie::Hash {
            # use ISO_32000::Table_329-Entries_in_a_user_property_dictionary;
            # also does ISO_32000::Table_329-Entries_in_a_user_property_dictionary;
            has Str $.N is entry(:required, :alias<key>); # The name of the user property.
            has $.V  is entry(:required, :alias<value>);    # The value of the user property.
            # While the value of this entry shall be any type of PDF object, conforming writers
            # should use only text string, number, and boolean values. Conforming readers
            # should display text, number and boolean values to users but need not display
            # values of other types; however, they should not treat other values as errors.
            has Str $.F is entry(:alias<formatted>); # A formatted representation of the value of V, that shall be used for
            # special formatting; for example “($123.45)” for the number -123.45. If this entry is
            # absent, conforming readers should use a default format.
            has Bool $.H is entry(:alias<hidden>); # If true, the attribute shall be hidden; that is, it shall not be shown in any
            # user interface element that presents the attributes of an object. Default value:
            # false.
        }
        has UserProperty @.P is entry(:alias<properties>, :required);
        method set-attribute($key, $value) {
            my @p := @.P;
            with (0 ..^ @p).first: { @p[$_]<N> eq $key } {
                @p[$_]<V> = $value;
            }
            else {
                @p.push:  UserProperty.COERCE: %( :N($key), :V($value) );
            }
        }
        method Hash {
            my @p := @.P;
            my % = (0 ..^ @p).map: { @p[$_]<N> => @p[$_]<V> }
        }
    }
    proto sub coerce-attributes($, Attributes) is export(:coerce-attributes) {*}
    multi sub coerce-attributes(Hash $atts where .<O> ~~ 'UserProperties', Attributes) {
        UserProperties.COERCE: $atts;
    }
    multi sub coerce-attributes(Hash $atts, Attributes) {
        Attributes.COERCE: $atts;
    }
    multi sub coerce-attributes($_, Attributes) {
        fail "unable to coerce struct element attributes: {.raku}";
    }
    has @.A is entry(:array-or-item);         # (Optional) A single attribute object or array of attribute objects associated with this structure element. Each attribute object shall be either a dictionary or a stream. If the value of this entry is an array, each attribute object in the array may be followed by an integer representing its revision number.
    sub new-atts($O) {
        my %atts = :$O;
        %atts<P> = [] if $O eq 'UserProperties';
        coerce-attributes %atts, Attributes;
    }
    has Attributes %!atts-by-owner;
    method vivify-attributes(Str:D :$owner!) {
        %!atts-by-owner{$owner} //= do {
            given self<A> {
                when Hash {
                    if .<O> ~~ $owner {
                        coerce-attributes($_, Attributes);
                    }
                    else {
                        # need to start a list containing multiple owners
                        # convert singular attribute to a list and append
                        my UInt $rev = self.revision;
                        my $new = new-atts $owner;
                        self<A> = [$_, $rev, $new, $rev];
                        $new;
                    }
                }
                when Array {
                    with .keys.reverse.first( -> $i {.[$i].isa(Hash) &&  .[$i].<O> ~~ $owner}) {
                        # owner already in the list
                        self<A>[$_+1] = self.revision;
                        coerce-attributes(self<A>[$_], Attributes);
                    }
                    else {
                        # append owner to the list
                        my UInt $rev = self.revision;
                        my $new = new-atts $owner;
                        self<A>.push($new);
                        self<A>.push: self.revision;
                        $new;
                    }
                }
                default { $_ = new-atts $owner }
            }
        }
    }
    method attribute-dicts {
        given self<A> {
            when Hash { (coerce-attributes($_, Attributes),) }
            when List {
                .keys.map(-> $i {.[$i]}).grep(Hash).map: { coerce-attributes($_, Attributes) }
            }
            default { () }
        }
    }
    has @.C is entry(:array-or-item);          # (Optional) An attribute class name or array of class names associated with this structure element. If the value of this entry is an array, each class name in the array may be followed by an integer representing its revision number.
# If both the A and C entries are present and a given attribute is
# specified by both, the one specified by the A entry shall take
    # precedence.
    method class-map-keys() {
        given self<C> {
            when Str { .List }
            when List {
                .keys.map(-> $i {.[$i]}).grep(Str)
            }
            default { () }
        }
    }

    has UInt $.R is entry(:alias<revision>, :default(0));         # (Optional) The current revision number of this structure element. The value shall be a non-negative integer. Default value: 0.
    has PDF::COS::TextString $.T  is entry(:alias<title>);        # (Optional) The title of the structure element, a text string representing it in human-readable form. The title should characterize the specific structure element, such as 'Chapter 1', rather than merely a generic element type, such as 'Chapter'.
    has PDF::COS::TextString $.Lang is entry;  # (Optional; PDF 1.4) A language identifier specifying the natural language for all text in the structure element except where overridden by language specifications for nested structure elements or marked content. If this entry is absent, the language (if any) specified in the document catalogue applies.
    has PDF::COS::TextString $.Alt is entry(:alias<alternative-description>); # (Optional) An alternate description of the structure element and its children in human-readable form, which is useful when extracting the document’s contents in support of accessibility to users with.
    has PDF::COS::TextString $.E is entry(:alias<expanded-form>); # (Optional; PDF 1.5) The expanded form of an abbreviation.
    has PDF::COS::TextString $.ActualText is entry;               # (Optional; PDF 1.4) Text that is an exact replacement for the structure element and its children. This replacement text (which should apply to as small a piece of content as possible) is useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes
}
