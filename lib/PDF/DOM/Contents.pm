use v6;

#| this role is applied to PDF::DOM::Type::Pages and PDF::DOM::Type::XObject::Form
role PDF::DOM::Contents {

    use PDF::DOM::Contents::Gfx;
    use PDF::DOM::Type::XObject;
    use PDF::DOM::Op :OpNames;

    method Contents is rw { self<Contents> }

    has PDF::DOM::Contents::Gfx $.pre-gfx = PDF::DOM::Contents::Gfx.new( :parent(self) ); #| prepended graphics
    has PDF::DOM::Contents::Gfx $.gfx     = PDF::DOM::Contents::Gfx.new( :parent(self) ); #| appended graphics

    method cb-finish {

        if $!pre-gfx.ops || $!gfx.ops {

	    my $content = self.decoded;
	    if $content.defined && $content.chars {
		# dont trust existing content. wrap it in q ... Q
		$!pre-gfx.ops.push(OpNames::Save);
		$!gfx.ops.unshift: OpNames::Restore;
	    }
	    my $prepend = $!pre-gfx.ops
		?? $!pre-gfx.content ~ "\n"
		!! '';

	    my $append = $!gfx.ops
		?? "\n" ~ $!gfx.content
		!! '';

	    $!pre-gfx.ops = ();
	    $!gfx.ops = ();
	    self.edit-stream(:$prepend, :$append)
		if $prepend.chars || $append.chars;
        }
    }

}
