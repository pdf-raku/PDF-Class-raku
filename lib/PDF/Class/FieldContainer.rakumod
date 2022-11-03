unit role PDF::Class::FieldContainer;

method fields {...}

multi method fields-hash(
    Array $fields-arr = self.fields,
    Str :$key! where 'T'|'TU'|'TR'
        --> Hash) {
    my %fields;

    for $fields-arr.list -> $field {
        %fields{ $_ } = $field
            with $field{$key};
    }

    %fields;
}

multi method fields-hash(Array $fields-arr = self.fields --> Hash) {
    my %fields;

    for $fields-arr.list -> $field {
        %fields{ $_ } = $field
            with $field.field-name;
    }

    %fields;
}

