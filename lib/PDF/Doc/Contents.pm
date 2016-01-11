use v6;

#| this role is applied to PDF::Doc::Type::Page, PDF::Doc::Type::Pattern and PDF::Doc::Type::XObject::Form
role PDF::Doc::Contents {

    use PDF::Doc::Contents::Gfx;
    use PDF::Doc::Type::XObject;
    use PDF::Doc::Op :OpNames;

    has PDF::Doc::Contents::Gfx $!pre-gfx; #| prepended graphics
    method pre-gfx { $!pre-gfx //= PDF::Doc::Contents::Gfx.new( :parent(self) ) }
    method pre-graphics(&code) { self.pre-gfx.block( &code ) }

    has PDF::Doc::Contents::Gfx $!gfx;  #| appended graphics
    method gfx(|c) {
	$!gfx //= do {
	    my Pair @ops = self.contents-parse;
	    my $gfx = PDF::Doc::Contents::Gfx.new( :parent(self), |c );
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
	PDF::Doc::Contents::Gfx.parse($contents);
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

        my $prepend = $!pre-gfx && $!pre-gfx.ops
            ?? $!pre-gfx.content ~ "\n"
            !! '';

        my $append = $!gfx && $!gfx.ops
            ?? $!gfx.content
            !! '';

        self.decoded = $prepend ~ $append;
    }

}
