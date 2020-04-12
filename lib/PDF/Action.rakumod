use v6;
use PDF::COS::Tie::Hash;
use PDF::Class::Type;

#| /Type /Action

role PDF::Action
    does PDF::COS::Tie::Hash
    does PDF::Class::Type::Subtyped {

    # use ISO_32000::Table_193-Entries_common_to_all_action_dictionaries;
    # also does ISO_32000::Table_193-Entries_common_to_all_action_dictionaries;

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Class::Defs :ActionName;

    has PDF::COS::Name $.Type is entry(:alias<type>) where 'Action';

    has ActionName $.S is entry(:required, :alias<subtype>);

    has PDF::Action @.Next is entry(:array-or-item);
}
