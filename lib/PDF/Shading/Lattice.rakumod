#| /ShadingType 5 - Lattice
unit class PDF::Shading::Lattice;

use PDF::COS::Stream;
use PDF::Shading;

also is PDF::COS::Stream;
also does PDF::Shading;

use PDF::COS::Tie;
use PDF::Function;

use ISO_32000::Table_83-Additional_Entries_Specific_to_a_Type_5_Shading_Dictionary;
also does ISO_32000::Table_83-Additional_Entries_Specific_to_a_Type_5_Shading_Dictionary;

use ISO_32000_2::Table_82-Additional_entries_specific_to_a_Type_5_shading_dictionary;
also does ISO_32000_2::Table_82-Additional_entries_specific_to_a_Type_5_shading_dictionary;

has UInt $.BitsPerCoordinate is entry(:required);	# [integer] (Required) The number of bits used to represent each vertex coordinate. The value is 1, 2, 4, 8, 12, 16, 24, or 32.
has UInt $.BitsPerComponent is entry(:required);  # (Required) The number of bits used to represent each color component. Valid values are 1, 2, 4, 8, 12, and 16.
has UInt $.VerticesPerRow is entry(:required);    # (Required) The number of vertices in each row of the lattice; the value must be greater than or equal to 2.
has Numeric @.Decode is entry(:required);         # (Required) An array of numbers specifying how to map vertex coordinates and color components into the appropriate ranges of values
has PDF::Function @.Function is entry(:array-or-item);   # (Optional) A 1-in, n-out function or an array of n 1-in, 1-out functions (where n is the number of color components in the shading dictionary’s color space).
