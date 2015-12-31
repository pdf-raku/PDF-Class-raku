use v6;

#| this role is applied to PDF::DOM::Type::Page, PDF::DOM::Type::Pattern and PDF::DOM::Type::XObject::Form
role PDF::DOM::Contents {

    use PDF::DOM::Contents::Gfx;
    use PDF::DOM::Type::XObject;
    use PDF::DOM::Op :OpNames;

    has PDF::DOM::Contents::Gfx $!pre-gfx; #| prepended graphics
    method pre-gfx { $!pre-gfx //= PDF::DOM::Contents::Gfx.new( :parent(self) ) }
    method pre-graphics(&code) { self.pre-gfx.block( &code ) }

    has PDF::DOM::Contents::Gfx $!gfx;  #| appended graphics
    multi method gfx { $!gfx //= PDF::DOM::Contents::Gfx.new( :parent(self) ) }
    multi method graphics(&code) { self.gfx.block( &code ) }
    multi method text(&code) { self.gfx.text( &code ) }

    method contents-parse(Str $contents = $.contents ) {
	PDF::DOM::Contents::Gfx.parse($contents);
    }

    method contents returns Str {
	$.decoded;
    }

    method render(&callback?) {
	self.cb-finish;
	my Array $ops = self.contents-parse;
	my $gfx = PDF::DOM::Contents::Gfx.new( :parent(self) );
	$gfx.callback = &callback
	    if &callback.defined;
	$gfx.ops: $ops;
	$gfx.finish;
    }

    method cb-finish {

	if ($!pre-gfx && $!pre-gfx.ops) || ($!gfx && $!gfx.ops) {

	    my $content = self.decoded;
	    if $content.defined && $content.chars {
		# dont trust existing content. wrap it in q ... Q
		$.pre-gfx.ops.push: OpNames::Save => [];
		$.gfx.ops.unshift: OpNames::Restore => [];
	    }
	    my $prepend = $!pre-gfx && $!pre-gfx.ops
		?? $!pre-gfx.content ~ "\n"
		!! '';

	    my $append = $!gfx && $!gfx.ops
		?? "\n" ~ $!gfx.content
		!! '';

	    $!pre-gfx = Nil;
	    $!gfx = Nil;
	    self.edit-stream(:$prepend, :$append)
		if $prepend.chars || $append.chars;
        }
    }

}
