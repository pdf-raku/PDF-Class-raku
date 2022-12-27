#| /Type /Action
unit role PDF::Action;

use PDF::COS::Tie::Hash;
use PDF::Class::Type;
also does PDF::COS::Tie::Hash;
also does PDF::Class::Type::Subtyped;

# use ISO_32000::Table_193-Entries_common_to_all_action_dictionaries;
# also does ISO_32000::Table_193-Entries_common_to_all_action_dictionaries;

use PDF::COS::Tie;
use PDF::COS::Name;
use PDF::Class::Defs :ActionSubtype;

has PDF::COS::Name $.Type is entry(:alias<type>) where 'Action';

has PDF::COS::Name $.S is entry(:required, :alias<subtype>) where ActionSubtype;

has PDF::Action @.Next is entry(:array-or-item);
