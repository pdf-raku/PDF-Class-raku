role PDF::Class::OutlineNode {
    use PDF::COS;
    use PDF::Destination :coerce-dest, :DestinationLike;
    has Array $.parents is rw;
    sub siblings($first) is rw {
        my class Siblings does Iterable {
            has $.first is required;
            my class Iteration does Iterator {
                has $.cur is required;
                method pull-one {
                    my $this = $!cur;
                    $_ = .Next with $!cur;
                    $this // IterationEnd;
                }
            }
            method iterator { Iteration.new: cur => $!first }
        }.new(:$first);
    }
    method add-kid(Hash $kid is copy = {}) {
        my $grand-kids = $kid<kids>:delete;
        my PDF::Destination $dest;
        with $kid<dest>:delete {
            when PDF::Destination { $dest = $_; }
            when DestinationLike  { warn "todo coerce dest: {.perl}" }
            default { warn "ignoring outline dest: {.gist}" }
        }
        $kid = PDF::COS.coerce($kid, (require PDF::Outline));
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
    #| .get Proxy Fetch not working
    method get-kids { siblings(self.First) }
    method kids is rw {
        Proxy.new(
            FETCH => { siblings(self.First) },
            STORE => -> $, @kids {
                self<First Last>:delete;
                self.add-kid($_) for @kids;
            });
    }
    method count { .abs with $.Count }
    method is-open is rw {
        Proxy.new(
            FETCH => -> $ { $_ >= 0 with $.Count },
            STORE => -> $, Bool() $open {
                $_ = .abs * ($open ?? 1 !! -1)
                    with $.Count
            }
        )
    }

}
