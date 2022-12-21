use v6;

#| /FunctionType 3 - Stitching
#| see [PDF 32000 Section 7.4.10 Type 3 (Stitching) Functions]
class PDF::Function::Stitching {
    use PDF::Function;
    also is PDF::Function;

    # use ISO_32000::Table_41-Additional_entries_specific_to_a_type_3_function_dictionary;
    # also does ISO_32000::Table_41-Additional_entries_specific_to_a_type_3_function_dictionary;

    use PDF::COS::Tie;

    has @.Functions is entry(:required);       # (Required) An array of k 1-input functions making up the stitching function. The output dimensionality of all functions must be the same, and compatible with the value of Range if Range is present.
    has Numeric @.Bounds is entry(:required);   # (Required) An array of k − 1 numbers that, in combination with Domain, define the intervals to which each function from the Functions array applies. Bounds elements must be in order of increasing value, and each value must be within the domain defined by Domain.
    has Numeric @.Encode is entry(:required);  # (Required) An array of 2 × k numbers that, taken in pairs, map each subset of the domain defined by Domain and the Bounds array to the domain of the corresponding function.

    class Transform
        is PDF::Function::Transform {
        has Range @.bounds is required;
        has Range @.encode is required;
        has PDF::Function::Transform @.functions is required;
        has UInt $!k;

        submethod TWEAK {
            die "stitching function should have one input"
                unless self.domain.elems == 1;
            $!k = @!functions.elems;
            die "Encode array length does not match Functions array"
                unless @!encode == $!k;
            die "bounds array length error"
                unless @!bounds.elems == $!k;
        }

        method calc(@in where .elems == 1) {
            my Numeric $x = self.clip(@in[0], @.domain[0]);
            my UInt $i = @!bounds.first: {$x ~~ $_}, :k;
            my Numeric $e = $.interpolate($x, @.bounds[$i], @.encode[$i]);
            my @out = @!functions[$i].calc([$e]);
            @out = [(@out Z @.range).map: { self.clip(.[0], .[1]) }]
                if @.range;
            @out;
        }
    }

    method calculator handles<calc> {
        my Range @domain = @.Domain.map: -> $a, $b { Range.new($a, $b) };
        my Range @range = do with $.Range {
            .map: -> $a, $b { Range.new($a, $b) }
        }
        my Range @encode = do given $.Encode {
            .keys.map: -> $k1, $k2 { .[$k1] .. .[$k2] }
        }
        my Range @bounds;
        my @funcs := @.Functions;
        my PDF::Function::Transform @functions = @funcs.keys.map: { @funcs[$_].calculator };
        my UInt $k = @functions.elems - 1;
        my @Bounds = @.Bounds;
        die "Bounds array length error: {@Bounds.elems} != $k"
            unless @Bounds.elems == $k;
        if $k {
            my Range $r := @domain[0];
            @bounds[0] = $r.min .. @Bounds[0];
            for 1 ..^ $k {
                @bounds[$_] = @Bounds[$_-1] .. @Bounds[$_];
            }
            @bounds[$k] = @Bounds[$k-1] .. $r.max;
        }
        else {
            @bounds = @domain;
        }
        Transform.new: :@domain, :@range, :@encode, :@functions, :@bounds;
    }
}
