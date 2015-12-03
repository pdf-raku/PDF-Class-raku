use v6;

use PDF::DOM::Contents::Text::Line;
use PDF::DOM::Contents::Text::Atom;
use PDF::DOM::Op :OpNames;

class PDF::DOM::Contents::Text::Block {
    has Numeric $.line-height;
    has Numeric $.font-height;
    has Numeric $.font-base-height;
    has Numeric $.font-size;
    has Str     $.font-key;
    has Numeric $.horiz-scaling = 100;
    has Numeric $.char-spacing = 0;
    has Numeric $.word-spacing = 0;
    has Numeric $.space-width;
    has Numeric $!width;
    has Numeric $!height;
    has @.lines;
    has @.overflow is rw;
    has Str $!align where 'left' | 'center' | 'right' | 'justify';
    has Str $.valign where 'top' | 'center' | 'bottom' | 'text';

    method actual-width(@lines = @!lines)  { @lines.max({ .actual-width }); }
    method actual-height { (+@!lines - 1) * $!line-height  +  $!font-height }

    multi submethod BUILD(Str :$text!,
                          :$font!,
                          :$!font-key = $font.key,
			  :$!font-size = 16,
                          :$kern       = False,
			  |c) {

	$!font-height = $font.height( $!font-size );
	$!font-base-height = $font.height( $!font-size, :from-baseline );
        $!space-width = $font.stringwidth( ' ', $!font-size );

        my @chunks = flat $text.comb(/ [ <![ - ]> [ \w | <:Punctuation> ] ]+ '-'?
                                || .
                                /).map( {
				    when /\n/  {' '}
                                    when $kern { $font.kern($_, $!font-size).list }
                                    default    { $font.filter($_) }
                                 });

        constant NO-BREAK-WS = rx/ <[ \c[NO-BREAK SPACE] \c[NARROW NO-BREAK SPACE] \c[WORD JOINER] ]> /;
        constant BREAKING-WS = rx/ <![ \c[NO-BREAK SPACE] \c[NARROW NO-BREAK SPACE] \c[WORD JOINER] ]> \s /;

        my @atoms;
        while @chunks {
            my $content = @chunks.shift;
            my %atom = :$content;
            %atom<space> = @chunks && @chunks[0] ~~ Numeric
                ?? @chunks.shift
                !! 0;
            %atom<width> = $font.stringwidth($content, $!font-size, :$kern);
            # don't atomize regular white-space
            next if $content ~~ BREAKING-WS;
            my Bool $followed-by-ws = ?(@chunks && @chunks[0] ~~ BREAKING-WS);
            my Bool $kerning = %atom<space> < 0;

            my $atom = PDF::DOM::Contents::Text::Atom.new( |%atom );
            if $kerning {
                $atom.sticky = True;
            }
            elsif $atom.content ~~ NO-BREAK-WS {
                $atom.elastic = True;
                $atom.sticky = True;
                @atoms[*-1].sticky = True
                    if @atoms;
            }
            elsif $followed-by-ws {
                $atom.elastic = True;
                $atom.space = $!space-width;
            }

            my Str $encoded = [~] $font.encode( $atom.content );
            $atom.encoded = $encoded
                unless $encoded eq $atom.content;

            @atoms.push: $atom;
        }

        self.BUILD( :@atoms, |c );
    }

    multi submethod BUILD(:@atoms!,
                          Numeric :$!line-height = $!font-size * 1.1,
			  Numeric :$!horiz-scaling = 100,
			  Numeric :$!char-spacing = 0,
                          Numeric :$!word-spacing = 0,
                          Numeric :$!width?,      #| optional constraint
                          Numeric :$!height?,     #| optional constraint
                          Str :$!align = 'left',
                          Str :$!valign = 'text',
        ) is default {

        my PDF::DOM::Contents::Text::Line $line;
        my Numeric $line-width = 0.0;
	my Numeric $char-count = 0.0;

	@atoms = @atoms;

        while @atoms {

            my @word;
            my $atom;
	    my $word-width = 0;

            repeat {
                $atom = @atoms.shift;
		$char-count += $atom.content.chars;
		$word-width += $atom.width + $atom.space;
                @word.push: $atom;
            } while $atom.sticky && @atoms;

            my $trailing-space = @word[*-1].space;
	    if $trailing-space > 0 {
		$char-count += $trailing-space * $!font-size / $!space-width;
		$trailing-space += $!word-spacing;
		$word-width += $!word-spacing;
	    }

	    my $visual-width = $line-width + $word-width - $trailing-space;
	    $visual-width += ($char-count - 1) * $!char-spacing
		if $char-count && $!char-spacing > 0;
	    $visual-width *= $!horiz-scaling / 100
		if $!horiz-scaling != 100;

            if !$line || ($!width && $line.atoms && $visual-width > $!width) {
                last if $!height && (@!lines + 1)  *  $!line-height > $!height;
                $line = PDF::DOM::Contents::Text::Line.new();
                $line-width = 0.0;
		$char-count = 0;
                @!lines.push: $line;
            }

            $line.atoms.append: @word;
            $line-width += $word-width;
        }

        my $width = $!width // self.actual-width(@!lines)
            if $!align eq 'justify';

        for @!lines {
            .atoms[*-1].elastic = False;
            .atoms[*-1].space = 0;
            .align($!align, :$width );
        }

        @!overflow = @atoms;
    }

    method width  { $!width //= self.actual-width }
    method height { $!height //= self.actual-height }

    method align($!align) {
        .align($!align)
            for self.lines;
    }

    method content(Bool :$nl = False) {

        my @content = :TL[ $!line-height ];
	my $space-size = -(1000 * $!space-width / $!font-size).round.Int;

        if $!valign ne 'text' {

            my $dy = do given $!valign {
                when 'center' { 0.5 }
                when 'bottom' { 1.0 }
                default { 0 }
            };

            # adopt html style text positioning. from the top of the font, not the baseline.
            @content.push: 'Td' => [0, $dy * $.height  -  $!font-base-height]
        }

        for $.lines.list {
            @content.push: .content(:$.font-size, :$space-size, :$!word-spacing);
            @content.push: OpNames::TextNextLine;
        }

        @content.pop
            if !$nl && @content;

        @content;
    }

}
