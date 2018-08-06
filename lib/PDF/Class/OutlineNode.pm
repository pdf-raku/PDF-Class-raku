role PDF::Class::OutlineNode {
    use PDF::COS;
    use PDF::Destination :coerce-dest, :DestinationArray;
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
    method add-kid(Hash $kid is copy = {}) {
        require PDF::Outline;
        my $grand-kids = $kid<kids>:delete;
        my PDF::Destination $dest;
        with $kid<dest>:delete {
            when PDF::Destination { $dest = $_; }
            when Hash { $dest = coerce-dest($_, PDF::Destination) }
            when DestinationArray {
                $dest = PDF::Destination.construct($_);
            }
            default { warn "ignoring outline <dest>: {.perl}" }
        }
        $kid = PDF::COS.coerce($kid, PDF::Outline);
        $kid.Dest = $_ with $dest;
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
        $kid.kids = $_ with $grand-kids;
        $kid;
    }
    method kids is rw {
        Proxy.new:
            :FETCH(sub ($) {siblings(self.First)}),
            :STORE(sub ($, @kids) {
                self<First Last>:delete;
                self.add-kid($_) for @kids;
            })
    }

}
