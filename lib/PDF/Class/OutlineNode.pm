role PDF::Class::OutlineNode {
    use PDF::COS;
    has Array $.parents is rw;
    sub siblings($cur) {
        my class Siblings does Iterable does Iterator {
            has $.cur;
            method iterator { self }
            method pull-one {
                my $this = $!cur;
                $_ = .Next with $!cur;
                $this // IterationEnd;
            }
        }.new( :$cur );
    }
    method kids {
        siblings($.First);
    }
    method add-kid($kid is copy = {}) {
        require PDF::Outline;
        $kid = PDF::COS.coerce($kid, PDF::Outline);
        $kid.parents //= [];
        $kid.parents.push: self;
        with self.Last {
            .Next = $kid;
            $kid.Prev = $_;
        }
        self.Last = $kid;
        self.First //= $kid;
        my %seen{Any};
        my @nodes = $kid;

        while @nodes {
            my $node = @nodes.shift;
            unless %seen{$node}++ {
                $node.Count++;
                with $node.parents {
                    @nodes.push: $_
                        for .list;
                }
            }
        }

    }
}
