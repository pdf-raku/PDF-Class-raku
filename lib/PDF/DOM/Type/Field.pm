use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;

# /Type /OutputIntent

class PDF::DOM::Type::Field
    is PDF::Object::Dict
    does PDF::DOM::Type['FT'] {

    use PDF::Object::Tie;
    # see [PDF 1.7 TABLE 8.69 Entries common to all field dictionaries]

    use PDF::Object::TextString;

    subset FieldTypeName of PDF::Object::Name
	where ( 'Btn' # Button
	      | 'Tx'  # Text
              | 'Ch'  # Choice
	      | 'Sig' # Signature
	      );

    has FieldTypeName $.FT is entry(:inherit);  #| Required for terminal fields; inheritable) The type of field that this dictionary describes
    has Hash $.Parent is entry(:indirect);      #| (Required if this field is the child of another in the field hierarchy; absent otherwise) The field that is the immediate parent of this one (the field, if any, whose Kids array includes this field). A field can have at most one parent; that is, it can be included in the Kids array of at most one other field.

    has Array $.Kids is entry;                  #| (Sometimes required, as described below) An array of indirect references to the immediate children of this field.
                                                #| In a non-terminal field, the Kids array is required to refer to field dictionaries that are immediate descendants of this field. In a terminal field, the Kids array ordinarily must refer to one or more separate widget annotations that are associated with this field. However, if there is only one associated widget annotation, and its contents have been merged into the field dictionary, Kids must be omitted.

    has PDF::Object::TextString $.T is entry;                       #| Optional) The partial field name

    has PDF::Object::TextString $.TU is entry;                      #| (Optional; PDF 1.3) An alternate field name to be used in place of the actual field name wherever the field must be identified in the user interface (such as in error or status messages referring to the field). This text is also useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes

    has PDF::Object::TextString $.TM is entry;                      #| (Optional; PDF 1.3) The mapping name to be used when exporting interactive form field data from the document.

    my subset FieldFlags of UInt where 0..7;
    has FieldFlags $.Ff is entry(:inherit);     #| Optional; inheritable) A set of flags specifying various characteristics of the field

    has Any $.V is entry(:inherit);             #| (Optional; inheritable) The field’s value, whose format varies depending on the field type

    has Any $.DV is entry(:inherit);            #| (Optional; inheritable) The default value to which the field reverts when a reset-form action is executed. The format of this value is the same as that of V.

    has Hash $.AA is entry;                     #| (Optional; PDF 1.2) An additional-actions dictionary defining the field’s behavior in response to various trigger events. This entry has exactly the same meaning as the AA entry in an annotation dictionary

    # see [PDF 1.7 TABLE 8.71 Additional entries common to all fields containing variable text]

    has Str $.DA is entry(:inherit);            #| (Required; inheritable) The default appearance string containing a sequence of valid page-content graphics or text state operators that define such properties as the field’s text size and color.

    my subset QuaddingFlags of UInt where 0..3;
    has QuaddingFlags $.Q is entry(:inherit);   #| (Optional; inheritable) A code specifying the form of quadding (justification) to be used in displaying the text:
                                                #| 0: Left-justified
                                                #| 1: 1Centered
                                                #| 2: Right-justified

    has Str $.DS is entry;                      #| Optional; PDF 1.5) A default style string

    use PDF::Object::Stream;
    my subset TextOrStream of Any where PDF::Object::TextString | PDF::Object::Stream;
    multi sub coerce(Str $value is rw) {
	$value = PDF::Object::TextString.new( :$value );
    }
    has TextOrStream $.RV is entry( :&coerce );             #| (Optional; PDF 1.5) A rich text string
    
}
