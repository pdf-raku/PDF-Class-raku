use v6;

unit role PDF::Field::Text;

use PDF::Field;
also does PDF::Field::_Instance;

use PDF::COS;
use PDF::COS::Tie;
use PDF::Class::Defs :TextOrStream;

use ISO_32000::Table_229-Additional_entry_specific_to_a_text_field;
also does ISO_32000::Table_229-Additional_entry_specific_to_a_text_field;

use ISO_32000_2::Table_232-Additional_entry_specific_to_a_text_field;
also does ISO_32000_2::Table_232-Additional_entry_specific_to_a_text_field;

has TextOrStream $.V is entry(:coerce(&coerce-text-or-stream), :inherit, :alias<value>);
has TextOrStream $.DV is entry(:coerce(&coerce-text-or-stream), :inherit, :alias<default-value>);

has UInt $.MaxLen is entry; # (Optional; inheritable) The maximum length of the field’s text, in characters.
