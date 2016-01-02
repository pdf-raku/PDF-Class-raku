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
    method gfx(|c) {
	$!gfx //= do {
	    my Pair @ops = self.contents-parse;
	    my $gfx = PDF::DOM::Contents::Gfx.new( :parent(self), |c );
	    if @ops && ! (@ops[0].key eq OpNames::Save && @ops[*-1].key eq OpNames::Restore) {
		@ops.unshift: OpNames::Save => [];
		@ops.push: OpNames::Restore => [];
	    }
	    $gfx.ops: @ops;
	    $gfx;
	}
    }
    method graphics(&code) { self.gfx.block( &code ) }
    method text(&code) { self.gfx.text( &code ) }

    method contents-parse(Str $contents = $.contents ) {
	PDF::DOM::Contents::Gfx.parse($contents);
    }

    method contents returns Str {
	$.decoded // '';
    }

    method render(&callback) {
	die "too late to install render callback"
	    if $!gfx;
	self.gfx(:&callback);
    }

    method cb-finish {

	if ($!pre-gfx && $!pre-gfx.ops) || ($!gfx && $!gfx.ops) {

	    my $prepend = $!pre-gfx && $!pre-gfx.ops
		?? $!pre-gfx.content ~ "\n"
		!! '';

	    my $append = $!gfx && $!gfx.ops
		?? $!gfx.content
		!! '';

	    self.decoded = $prepend ~ $append;
        }
    }

}
