use PDF::Attributes;
unit role PDF::Attributes::UserProperties does PDF::Attributes;
    # use ISO_32000::Table_328-Additional_entries_in_an_attribute_object_dictionary_for_user_properties;
    # also does ISO_32000::Table_328-Additional_entries_in_an_attribute_object_dictionary_for_user_properties
use PDF::COS::Tie;
use PDF::COS::Tie::Hash;
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
    with (^@p).first: { @p[$_]<N> eq $key } {
        @p[$_]<V> = $value;
    }
    else {
        @p.push:  UserProperty.COERCE: %( :N($key), :V($value) );
    }
}
method Hash {
    my @p := @.P;
    my % = (^@p).map: { @p[$_]<N> => @p[$_]<V> }
}
