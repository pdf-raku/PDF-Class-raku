role PDF::Field {
 
    use PDF::COS::Tie::Hash;
    use PDF::Class::Type;

    also does PDF::COS::Tie::Hash;
    also does PDF::Class::Type::Subtyped;

    use PDF::COS::Tie;
    use PDF::COS::TextString;
    use PDF::COS::Dict;
    use PDF::COS::Name;
    use PDF::Field::AdditionalActions;
    use PDF::Class::Defs :AnnotLike, :TextOrStream;

    my subset FieldSubtypeName of PDF::COS::Name
        where ( 'Btn' # Button
              | 'Tx'  # Text
              | 'Ch'  # Choice
              | 'Sig' # Signature
              );

    method field-delegate( PDF::COS::Dict $dict) {
        my $field-role = do with $dict<FT> {
            when 'Btn' {'Button'}
            when 'Tx'  {'Text'}
            when 'Ch'  {'Choice'}
            when 'Sig' {'Signature'}
            default { warn "ignoring Field /FT entry: $_"; Nil }
        }
        else {
            warn "terminal Field lacks /FT entry"
                unless $dict<Kids>:exists
        }

        with $field-role {
            PDF::COS.loader.find-delegate( 'Field', $field-role, :base-class(PDF::Field) );
        }
        else {
            PDF::Field
        }
    }

    multi sub coerce-field(PDF::COS::Dict() $dict, PDF::Field $field) is export(:coerce-field) {
        # refuse to coerce an annotation as a field
        my PDF::Field:U $class = $field.field-delegate( $dict );
        $class.COERCE: $dict;
    }
    # used by FDF/t/field-imports.t
    method coerce-field(Hash $dict) {
        coerce-field($dict, PDF::Field);
    }

    method type { 'Field' }
    has FieldSubtypeName $.FT is entry(:inherit, :alias<subtype>);  # Required for terminal fields; inheritable) The type of field that this dictionary describes
    has PDF::Field $.Parent is entry(:indirect);      # (Required if this field is the child of another in the field hierarchy; absent otherwise) The field that is the immediate parent of this one (the field, if any, whose Kids array includes this field). A field can have at most one parent; that is, it can be included in the Kids array of at most one other field.

    my subset FieldLike is export(:FieldLike) of Hash where { (.<FT>:exists) || (.<Kids>:exists) }

    my subset AnnotOrField of Hash where AnnotLike|PDF::Field;
    multi sub coerce-field( FieldLike $dict, AnnotOrField) {
        my PDF::Field:U $class = PDF::Field.field-delegate( $dict );
        $class.COERCE: $dict;
    }
    multi sub coerce-field( $_, AnnotOrField) {
        warn "unable to coerce {.raku} to an Annotation or Field";
    }

    has AnnotOrField @.Kids is entry(:indirect, :coerce(&coerce-field)); # (Sometimes required, as described below) An array of indirect references to the immediate children of this field.
                                                # In a non-terminal field, the Kids array is required to refer to field dictionaries that are immediate descendants of this field. In a terminal field, the Kids array ordinarily must refer to one or more separate widget annotations that are associated with this field. However, if there is only one associated widget annotation, and its contents have been merged into the field dictionary, Kids must be omitted.

    #| return any terminal descendants, or self
    method fields {
        my PDF::Field @fields;
        with self.Kids -> $kids {
            for $kids.keys {
                my $kid := $kids[$_];
                if $kid ~~ FieldLike {
                    @fields.append: $kid.fields;
                }
            }
        }
        @fields.push(self) unless @fields;
        @fields;
    }

    #| take terminal fields
    method take-fields {
        my Bool $taken;
        with self.Kids -> $kids {
            for $kids.keys {
                my $kid := $kids[$_];
                if $kid ~~ FieldLike {
                    $taken = True;
                    $kid.take-fields;
                }
            }
        }
        take self unless $taken;
    }

    method value is rw {
        Proxy.new(
            FETCH => {
                self.V // self.DV; # actual value or default value
            },
            STORE => -> $, $v {
                self.ASSIGN-KEY('V', $v, :check);
            }
        );
    }

    #| return immediate annotations only. return ourself, if we're an annotation,
    #| otherwise return any annots from our immediate kids
    method annots {
        my @annots;
        if self ~~ AnnotLike {
            @annots.push: self
        }
        elsif  self.Kids.defined {
            for self.Kids.keys {
                my $kid = self.Kids[$_];
                @annots.append: $kid.annots
                    if $kid ~~ AnnotLike && $kid !~~ FieldLike;
            }
        }
        @annots;
    }

    has PDF::COS::TextString $.T is entry(:alias<key>);      # Optional) The partial field name
    multi method field-name($fld is copy:) {
        my @partial;
        while $fld.defined && $fld<T>.defined {
            @partial.unshift: $fld<T>;
            $fld = $fld<Parent>;
        }
        @partial ?? @partial.join('.') !! Str;
    }

    has PDF::COS::TextString $.TU is entry(:alias<label>);     # (Optional; PDF 1.3) An alternate field name to be used in place of the actual field name wherever the field must be identified in the user interface (such as in error or status messages referring to the field). This text is also useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes

    has PDF::COS::TextString $.TM is entry(:alias<tag>);     # (Optional; PDF 1.3) The mapping name to be used when exporting interactive form field data from the document.

    # See [ISO-32000 Table 221 - Field flags common to all field types]
    my Int enum FieldFlag is export(:FieldFlag) « :FieldReadonly(1) :FieldRequired(2) :FieldNoExport(3)»;

    # See [ISO-32000 Table 226 - Field flags common to button fields]
    my Int enum BtnFieldFlag is export(:BtnFieldFlag) « :BtnFieldNoToggleToOff(15) :BtnFieldRadio(16) :BtnFieldPushButton(17) :BtnFieldRadiosInUnison(26) »;

    # See [ISO-32000 Table 228 - Field flags common to text fields]
    my Int enum TextFieldFlag is export(:TextFieldFlag) «
        :TextFieldMultiline(13)  :TextFieldPassword(14)
        :TextFieldFileSelect(21) :TextFieldDoNotSpellCheck(23)
        :TextFieldDoNotScroll(24) :TextFieldComb(25) :TextFieldRichText(26) »;

    # See [ISO-32000 Table 230 - Field flags common to choice fields]
    my Int enum ChoiceFieldFlag is export(:ChoiceFieldFlag) «
      :ChoiceFieldCombo(18) :ChoiceFieldEdit(19)
      :ChoiceFieldDoNotSpellCheck(23) :ChoiceFieldCommitOnSelChange(24)
    »;

    my subset FeildFlagsInt of UInt where 0 ..^ 2 +< 27;
    has UInt $.Ff is entry(:inherit, :alias<field-flags>, :default(0));           # Optional; inheritable) A set of flags specifying various characteristics of the field

    has PDF::Field::AdditionalActions $.AA is entry(:alias<additional-actions>);                     # (Optional; PDF 1.2) An additional-actions dictionary defining the field’s behavior in response to various trigger events. This entry has exactly the same meaning as the AA entry in an annotation dictionary

    has Str $.DA is entry(:inherit, :alias<default-appearance>);            # (Required; inheritable) The default appearance string containing a sequence of valid page-content graphics or text state operators that define such properties as the field’s text size and color.

    my subset QuaddingFlags of UInt where ^3;
    has QuaddingFlags $.Q is entry(:inherit, :alias<quadding>);   # (Optional; inheritable) A code specifying the form of quadding (justification) to be used in displaying the text:
                                                # 0: Left-justified
                                                # 1: Centered
                                                # 2: Right-justified

    has PDF::COS::TextString $.DS is entry(:alias<default-style>);     # Optional; PDF 1.5) A default style string

    has TextOrStream $.RV is entry(:coerce(&coerce-text-or-stream), :alias<rich-text>);  # (Optional; PDF 1.5) A rich text string

    method cb-check {
        die "Fields should have an /FT or /Kids entry"
            unless self ~~ FieldLike;
    }
}

# Each instance has particular definitions for /V and /DV
role PDF::Field::_Instance does PDF::Field {
    use ISO_32000::Table_220-Entries_common_to_all_field_dictionaries;
    also does ISO_32000::Table_220-Entries_common_to_all_field_dictionaries;
    use ISO_32000::Table_222-Additional_entries_common_to_all_fields_containing_variable_text;
    also does ISO_32000::Table_222-Additional_entries_common_to_all_fields_containing_variable_text;

    use ISO_32000_2::Table_226-Entries_common_to_all_field_dictionaries;
    also does ISO_32000_2::Table_226-Entries_common_to_all_field_dictionaries;
    use ISO_32000_2::Table_228-Additional_entries_common_to_all_fields_containing_variable_text;
    also does ISO_32000_2::Table_228-Additional_entries_common_to_all_fields_containing_variable_text;

}
