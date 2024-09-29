#| Standard list attribute
unit role PDF::Attributes::List;

use PDF::Attributes;
also does PDF::Attributes;

use ISO_32000::Table_347-Standard_list_attribute;
also does ISO_32000::Table_347-Standard_list_attribute;

use ISO_32000_2::Table_382-Standard_list_attributes;
also does ISO_32000_2::Table_382-Standard_list_attributes;

use PDF::COS::Tie;
use PDF::COS::Name;

my subset Numbering of PDF::COS::Name where 'None'|'Unordered'|'Ordered'|'Description'|'Disc'|'Circle'|'Square'|'Decimal'|'UpperRoman'|'LowerRoman'|'UpperAlpha'|'LowerAlpha';

has Numbering $.ListNumbering is entry(:default<None>);	# (Optional; inheritable) The numbering system used to generate the content of the Lbl (Label) elements in an autonumbered list, or the symbol used to identify each item in an unnumbered list. The value of the ListNumbering is one of the following, and is applied as described here.
	# None No autonumbering; Lbl elements (if present) contain arbitrary text not subject to any numbering scheme
	# Disc Solid circular bullet
	# Circle Open circular bullet
	# Square Solid square bullet
	# Decimal Decimal arabic numerals (1–9, 10–99, …)
	# UpperRoman Uppercase roman numerals (I, II, III, IV, …)
	# LowerRoman Lowercase roman numerals (i, ii, iii, iv, …)
	# UpperAlpha Uppercase letters (A, B, C, …)
	# LowerAlpha Lowercase letters (a, b, c, …)
	# Default value: None.
	# The alphabet used for UpperAlpha and LowerAlpha is determined by the prevailing Lang entry (see 14.9.2, “Natural Language Specification”).
	# The set of possible values may be expanded as Unicode identifies additional numbering systems. A conforming reader ignores any value not listed in this table; it behaves as though the value were Non

has Bool $.ContinuedList is entry; # (Optional; PDF 2.0) A flag specifying whether the list is a continuation of a previous list in the structure tree

has PDF::COS::ByteString $.ContinuedFrom is entry; # (Optional; PDF 2.0) The ID of the list for which this list is a continuation.
