#| Table 346 – Standard column attributes
unit role PDF::Attributes::Column;

#use role ISO_32000::Table_346-Standard_column_attributes;
#also does role ISO_32000::Table_346-Standard_column_attributes;

use PDF::Attributes;
also does PDF::Attributes;

use PDF::COS::Tie;

my role Table_346-Column_Attributes {

    has Int $.ColumnCount is entry(:default(1));	# (Optional; not inheritable; PDF 1.6) The number of columns in the content of the grouping element. Default value: 1.

    has Numeric $.ColumnGap is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.6) The desired space between adjacent columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the space between all columns. If the value is an array, it contains numbers, the first element specifying the space between the first and second columns, the second specifying the space between the second and third columns, and so on. If there are fewer than ColumnCount - 1 numbers, the last element specifies all remaining spaces; if there are more than ColumnCount - 1 numbers, the excess array elements is ignored.

    has Numeric $.ColumnWidths is entry(:array-or-item);	# (Optional; not inheritable; PDF 1.6) The desired width of the columns, measured in default user space units in the inline-progression direction. If the value is a number, it specifies the width of all columns. If the value is an array, it contains numbers, representing the width of each column, in order. If there are fewer than ColumnCount numbers, the last element specifies all remaining widths; if there are more than ColumnCount numbers, the excess array elements is ignored.
}
also does Table_346-Column_Attributes;
