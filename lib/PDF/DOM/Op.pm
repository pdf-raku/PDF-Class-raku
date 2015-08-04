use v6;

use PDF::Writer;
use PDF::Object::Util :from-ast;

role PDF::DOM::Op {

    has @!ops;

    #| some convenient mnemomic names
    BEGIN my Str enum OpNames is export(:OpNames) «
        :BeginImage<BI> :ImageData<ID> :EndImage<EI>
        :BeginMarkedContent<BMC> :EndMarkedContent<EMC>
        :BeginText<BT> :EndText<ET>
        :BeginIgnore<BX> :EndIgnore<EX>
        :CloseEOFillStroke<b*> :CloseFillStroke<b> :EOFillStroke<B*>
        :FillStroke<B> :CurveTo<c> :ConcatMatrix<cm>
        :SetFillColorSpace<cs> :SetStrokeColorSpace<CS> :SetDash<d>
        :SetCharWidth<d0> :SetCacheDevice<d1> :XObject<Do>
        :MarkPoint<DP> :EOFill<f*> :Fill<f> :SetStrokeGray<G>
        :SetFillGray<g> :SetGraphicsState<gs> :ClosePath<h> :SetFlat<i>
        :SetLineJoin<j> :SetLineCap<J> :SetFillCMYK<k>
        :SetStrokeCMYK<K> :LineTo<l> :MoveTo<m> :SetMiterLimit<M>
        :MarkPoint2<MP> :EndPath<n> :Save<q> :Restore<Q>
        :Rectangle<re> :SetFillRGB<rg> :SetStrokeRGB<RG>
        :SetRenderingIntent<ri> :CloseStroke<s> :Stroke<S>
        :SetStrokeColor<SC> :SetFillColor<sc> :SetFillColorN<scn>
        :SetStrokeColorN<SCN> :ShFill<sh> :TextNextLine<T*>
        :SetCharSpacing<Tc> :TextMove<Td> :TextMoveSet<TD>
        :SetFont<Tf> :ShowText<Tj> :ShowSpaceText<TJ>
        :SetTextLeading<TL> :SetTextMatrix<Tm> :SetTextRender<Tr>
        :SetTextRise<Ts> :SetWordSpacing<Tw> :SetHorizScaling<Tz>
        :CurveTo1<v> :EOClip<W*> :Clip<W> :SetLineWidth<w>
        :CurveTo2<y> :MoveSetShowText<"> :MoveShowText<'>
    »;

    my constant TextOps = set <T* Tc Td TD Tf Tj TJ TL Tm Tr Ts Tw Tz>;
    my constant GraphicOps = set <cm w J j M d ri i gs>;
    my constant ShadingOps = set <CS cs SC SCN sc scn G g RG rg K k>;
    has %.gstate = %(:CTM[ 1, 0, 0, 1, 0, 0 ]);

    has Array:_ $!Tm;      #| text matrix

    # *** TEXT STATE ***
    has Numeric $!Tc = 0;   #| character spacing
    has Numeric $!Tw = 0;   #| word spacing
    has Numeric $!Th = 100; #| horizontal scaling
    has Numeric $!Tl = 0;   #| leading
    has Str $!Tf;           #| font entry name, e.g. 'F1'
    has Numeric $!Tfs;      #| font size
    has Numeric $!Trise = 0;

    has @!gsave;
    has @!tags;
    has Bool $.in-text-block = False;

    method TextMatrix  is rw { $!Tm  }

    method CharSpacing  is rw { $!Tc  }
    method WordSpacing  is rw { $!Tw  }
    method HorizScaling is rw { $!Th  }
    method TextLeading  is rw { $!Tl  }
    method FontKey      is rw { $!Tf  }
    method FontSize     is rw { $!Tfs }
    method TextRise     is rw { $!Trise }

    method GraphicsMatrix is rw { %!gstate<CTM>  }

    #| BI dict ID stream EI
    multi sub op(Str $op! where 'BI',
                 Hash $dict = {}) {
        $op => [ :$dict ];
    }
    multi sub op(Str $op! where 'ID',
                 Str $encoded = '') {
        $op => [ :$encoded ];
    }
    multi sub op(Str $op! where 'EI') {
        $op
    }

    multi sub op(Str $op! where 'BX' | 'EX',
                 *@args) {
        die "todo ignored content BX [lines] EX: $op";
    }

    multi sub op(Str $op! where 'BT' | 'ET' | 'EMC' | 'BX' | 'EX' | 'b*' | 'b' | 'B*' | 'B' | 'f*' | 'F' | 'f'
                                     | 'h' | 'n' | 'q' | 'Q' | 's' | 'S' | 'T*' | 'W*' | 'W') {
        $op => [];
    }
    #| tag                     BMC | MP
    #| name                    cs | CS | Do | sh
    #| dictname                gs
    #| intent                  ri
    multi sub op(Str $op! where 'BMC' | 'cs' | 'CS' | 'Do' | 'gs' | 'MP' | 'ri' | 'sh',
        Str $name!) {
        $op => [ :$name ]
    }
    #| string                  Tj | '
    multi sub op(Str $op! where 'Tj' | "'",
        Str $literal!) {
        $op => [ :$literal ]
    }
    #| array                   TJ
    multi sub op(Str $op! where 'TJ',
        Array $args!) {
        my @array = $args.map({
            when Str     { :literal($_) }
            when Numeric { :int(.Int) }
            when Pair    { $_ }
            default {die "invalid entry in $op array: {.perl}"}
        });
        $op => [ :@array ];
    }
    multi sub op(Str $op! where 'Tf',
        Str $name!, Numeric $real!) {
        $op => [ :$name, :$real ]
    }
    #| name dict              BDC | DP
    multi sub op(Str $op! where 'BDC' | 'DP',
        Str $name!, Hash $dict!) {
        $op => [ :$name, :$dict ]
    }
    #| dashArray dashPhase    d
    multi sub op(Str $op! where 'd',
        Array $args!, Numeric $real!) {
        my @array = $args.map({
            when Int     { :int(.Int) }
            when Pair    { $_ }
            default {die "invalid entry in $op array: {.perl}"}
        });
        $op => [ :@array, :$real ];
    }
    #| flatness               i
    #| gray                   g | G
    #| miterLimit             m
    #| charSpace              Tc
    #| leading                TL
    #| rise                   Ts
    #| wordSpace              Tw
    #| scale                  Tz
    #| lineWidth              w
    multi sub op(Str $op! where 'i' | 'g' | 'G' | 'M' | 'Tc' | 'TL' | 'Ts' | 'Tw' | 'Tz' | 'w',
        Numeric $real!) {
        $op => [ :$real ]
    }
    #| lineCap                J
    #| lineJoin               j
    #| render                 Tr
    multi sub op(Str $op! where 'j' | 'J' | 'Tr',
        Int $int!) {
        $op => [ :$int ]
    }
    #| x y                    m l
    #| wx wy                  d0
    #| tx ty                  Td TD
    multi sub op(Str $op! where 'd0' | 'l' | 'm' | 'Td' | 'TD',
        Numeric $n1!, Numeric $n2!) {
        $op => [ :real($n1), :real($n2) ]
    }
    #| aw ac string           "
    multi sub op(Str $op! where '"',
        Numeric $n1!, Numeric $n2!, Str $literal! ) {
        $op => [ :real($n1), :real($n2), :$literal ]
    }
    #| r g b                  rg | RG
    multi sub op(Str $op! where 'rg' | 'RG',
        Numeric $n1!, Numeric $n2!, Numeric $n3!) {
        $op => [ :real($n1), :real($n2), :real($n3) ]
    }
    #| c m y k                k | K
    #| x y width height       re
    #| x2 y2 x3 y3            v y
    multi sub op(Str $op! where 'k' | 'K' | 're' | 'v' | 'y',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4) ]
    }
    #| x1 y1 x2 y2 x3 y3      c | cm
    #| wx wy llx lly urx ury  d1
    #| a b c d e f            Tm
    multi sub op(Str $op! where 'c' | 'cm' | 'd1' | 'Tm',
        Numeric $n1!, Numeric $n2!, Numeric $n3!, Numeric $n4!, Numeric $n5!, Numeric $n6!) {
        $op => [ :real($n1), :real($n2), :real($n3), :real($n4), :real($n5), :real($n6) ]
    }
    # c1, ..., cn             sc | SC
    multi sub op(Str $op! where 'sc' | 'SC', *@args is copy) {

        die "too few arguments to: $op"
            unless @args;

        @args = @args.map({ 
            when Pair    {$_}
            when Numeric { :real($_) }
            default {
                die "$op: bad argument: {.perl}"
            }
        });

        $op => [ @args ]
    }
    # c1, ..., cn [name]      scn | SCN
    multi sub op(Str $op! where 'scn' | 'SCN', *@args is copy) {

        # scn & SCN have an optional trailing name
        my Str $name = @args.pop
            if +@args && @args[*-1] ~~ Str;

        die "too few arguments to: $op"
            unless $name.defined || @args;

        @args = @args.map({ 
            when Pair    {$_}
            when Numeric { :real($_) }
            default {
                die "$op: bad argument: {.perl}"
            }
        });

        @args.push: (:$name) if $name.defined;

        $op => [ @args ]
    }
    multi sub op(Str $op!, *@args) {
        die "bad operation: $op @args[]";
    }
    #| semi-raw and a little dwimmy e.g:  op('TJ' => [[:literal<a>, :hex-string<b>, 'c']])
    #|                                     --> :TJ( :array[ :literal<a>, :hex-string<b>, :literal<c> ] )
    multi sub op(Pair $raw!) {
        my Str $op = $raw.key;
        my List $input_vals = $raw.value;
        # validate the operation and get fallback coercements for any missing pairs
        my @vals = $raw.value.map({ from-ast($_) });
        my $opn = op($op, |@vals);
        unless $opn ~~ Str {
            my $coerced_vals = $opn.value;
            # looks ok, pass it thru
            my @ast-values = $input_vals.pairs.map({ .value ~~ Pair
                                                        ?? .value
                                                        !! $coerced_vals[.key] });
            $opn = $op => [ @ast-values ];
        }
        $opn;
    }

    multi sub op(*@args) is default {
        die "invalid op: {@args.perl}";
    }

    method op(*@args is copy) {
        my $opn = op(|@args);
	my Str $op-name;

        if $opn ~~ Pair {
	    $op-name = $opn.key.Str;
	    @args = @( $opn.value.map({ .value }) );
	}
	else {
	    $op-name = $opn.Str;
	}

	warn "text operation '$op-name' outside of a BT ... ET text block\n"
	    if $op-name ∈ TextOps && !$!in-text-block;

	if !@!gsave {
	    warn "graphics operation '$op-name' outside of a q ... Q graphics block\n"
		if $op-name ∈ GraphicOps;

	    warn "shading operation '$op-name' outside of a q ... Q graphics block\n"
		if $op-name ∈ ShadingOps;
	}

	@!ops.push($opn);
        $.g-track($op-name, |@args );

	@!ops[*-1];
    }

    multi method ops(Str $ops!) {
	$.ops( self.parse($ops) );
    }

    multi method ops(Array $ops?) {
	if $ops.defined {
	    self.op($_)
		for $ops.list
	}
        @!ops;
    }

    method parse(Str $content) {
	use PDF::Grammar::Content;
	use PDF::Grammar::Content::Actions;
	state $actions //= PDF::Grammar::Content::Actions.new;
	PDF::Grammar::Content.parse($content, :$actions)
	    // die "unable to parse content stream: $content";
	$/.ast
    }

    multi method g-track('q') {
        my %gclone = %!gstate.pairs.map( -> $p { $p.key => $p.value.clone });
        @!gsave.push: %gclone.item;
    }
    multi method g-track('Q') {
        die "bad nesting; Restore(Q) operator not matched by preceeding Save(q) operator in PDF content\n"
            unless @!gsave;
        %!gstate = @!gsave.pop.pairs;
	Restore;
    }
    multi method g-track('cm', *@transform) {
        use PDF::DOM::Util::TransformMatrix;
        my Array $CTM = PDF::DOM::Util::TransformMatrix::multiply($.GraphicsMatrix, @transform);
        %!gstate<CTM> = $CTM;
    }
    multi method g-track('BT') {
        die "illegal nesting of BT text-blocks in PDF content\n"
            if @!tags && @!tags[*-1] eq 'BT';
        $!Tm = [ 1, 0, 0, 1, 0, 0 ];
	@!tags.push: 'BT';
        $!in-text-block = True;
    }
    multi method g-track('ET') {
	die "closing ET without opening BT in PDF content\n"
	    unless @!tags && @!tags[*-1] eq 'BT';
        $!Tm = Nil;
	@!tags.pop;
        $!in-text-block = False;
    }
    multi method g-track('BMC') {
	@!tags.push: 'BMC';
    }
    multi method g-track('EMC') {
	die "closing EMC without opening BMC in PDF content\n"
	    unless @!tags && @!tags[*-1] eq 'BMC';
	@!tags.pop;
    }
    multi method g-track('Tc', Numeric $Tc!) {
	$.CharSpacing = $Tc
    }
    multi method g-track('Tw', Numeric $Tw!) {
        $.WordSpacing = $Tw;
    }
    multi method g-track('Tz', Numeric $Th!) {
        $.HorizScaling = $Th;
    }
    multi method g-track('TL', Numeric $TL!) {
	$.TextLeading = $TL
    }
    multi method g-track('Tf', Str $Tf!, Numeric $Tfs!) {
        if self.can('parent') {
            die "unknown font key: /$Tf"
                unless self.parent.resource-entry('Font', $Tf);
        }
        $.FontKey = $Tf;     #| e.g. 'F2'
        $.FontSize = $Tfs;   #| e.g. 16
    }
    multi method g-track('Ts', Numeric $Ts!) {
	$.TextRise = $Ts
    }
    multi method g-track('Tm', *@Tm) {
	$!Tm = [ @Tm ];
    }
    multi method g-track('Td', Numeric $tx!, Numeric $ty) {
        $.TextMatrix[4] += $tx;
        $.TextMatrix[5] += $ty;
    }
    multi method g-track('TD', Numeric $tx!, Numeric $ty) {
        $.TextLeading = - $ty;
        $.g-track(TextMove, $tx, $ty);
    }
    multi method g-track('T*') {
        $.g-track(TextMove, 0, $.TextLeading);
    }
    multi method g-track(*@args) is default {}

    method content {
	die "Unclosed @!tags[] at end of content stream\n"
	    if @!tags;
	die "q(Save) unmatched by closing Q(Restore) at end of content stream\n"
	    if @!gsave;
        use PDF::Writer;
        my $writer = PDF::Writer.new;
        my @content = @!ops;
        $writer.write( :@content );
    }

    # e.g. $.Restore :== $.op('Q', [])
    multi method FALLBACK(Str $op-name where {OpNames.enums{$op-name}:exists},
			  *@args,
	) {
	my $op = OpNames.enums{$op-name};
	my &op-meth = method (*@a) { self.op($op, |@a) };
        self.WHAT.^add_method($op-name, &op-meth );
        self."$op-name"(|@args);
    }

    multi method FALLBACK($name) is default { die "unknown method: $name\n" }

}
