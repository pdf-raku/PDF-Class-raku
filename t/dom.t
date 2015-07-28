use v6;
use Test;

use PDF::Storage::IndObj;
use PDF::DOM::Type;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use lib '.';
use t::Object :to-obj;

plan 51;

# crosschecks on /Type
require ::('PDF::DOM::Type::Catalog');
my $dict = { :Outlines(:ind-ref[2, 0]), :Type( :name<Catalog> ), :Pages{ :Type( :name<Pages> ) } };
my $catalog-obj = ::('PDF::DOM::Type::Catalog').new( :$dict );
isa-ok $catalog-obj, ::('PDF::DOM::Type::Catalog');
isa-ok $catalog-obj.Type, Str, 'catalog $.Type';
is $catalog-obj.Type, 'Catalog', 'catalog $.Type';
is $catalog-obj.type, 'Catalog', 'catalog $.type';
ok ! $catalog-obj.subtype.defined, 'catalog $.subtype';

$dict<Type>:delete;
lives-ok {$catalog-obj = ::('PDF::DOM::Type::Catalog').new( :$dict )}, 'catalog .new with valid /Type - lives';
isa-ok $catalog-obj.Type, Str, 'catalog $.Type';
is $catalog-obj.Type, 'Catalog', 'catalog $.Type';

$dict<Type> = :name<Wtf>;
dies-ok {::('PDF::DOM::Type::Catalog').new( :$dict )}, 'catalog .new with invalid /Type - dies';

my $input = q:to"--END--";
16 0 obj
<< /Type /Font /Subtype /TrueType
   /BaseFont /CourierNewPSMT
   /Encoding /WinAnsiEncoding
   /FirstChar 111
    /FontDescriptor 15 0 R
   /LastChar 111
   /Widths [ 600 ] >>
endobj
--END--

my $actions = PDF::Grammar::PDF::Actions.new;
PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
my $ast = $/.ast;

# misc types follow

my $ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $tt-font-obj = $ind-obj.object;
isa-ok $tt-font-obj, ::('PDF::DOM::Type::Font::TrueType');
is $tt-font-obj.Type, 'Font', 'tt font $.Type';
is $tt-font-obj.Subtype, 'TrueType', 'tt font $.Subype';
is $tt-font-obj.Encoding, 'WinAnsiEncoding', 'tt font $.Encoding';
is $tt-font-obj.type, 'Font', 'tt font type accessor';
is $tt-font-obj.subtype, 'TrueType', 'tt font subtype accessor';

require ::('PDF::DOM::Type::Font::Type0');
$dict = to-obj :dict{ :BasedFont(:name<Wingdings-Regular>), :Encoding(:name<Identity-H>) };
my $t0-font-obj = ::('PDF::DOM::Type::Font::Type0').new( :$dict );
is $t0-font-obj.Type, 'Font', 't0 font $.Type';
is $t0-font-obj.Subtype, 'Type0', 't0 font $.Subype';
is $t0-font-obj.Encoding, 'Identity-H', 't0 font $.Encoding';

use PDF::DOM::Type::Font::Type1;
class SubclassedType1Font is PDF::DOM::Type::Font::Type1 {};
my $sc-font-obj = SubclassedType1Font.new;
is $sc-font-obj.Type, 'Font', 'sc font $.Type';
is $sc-font-obj.Subtype, 'Type1', 'sc font $.Subype';

my $enc-ast = :ind-obj[5, 2, :dict{ :Type( :name<Encoding> ), :BaseEncoding( :name<MacRomanEncoding> ) } ];
my $enc-ind-obj = PDF::Storage::IndObj.new( |%($enc-ast) );
my $enc-obj = $enc-ind-obj.object;
isa-ok $enc-obj, ::('PDF::DOM::Type::Encoding');
is $enc-obj.Type, 'Encoding', '$enc.Type';
is $enc-obj.BaseEncoding, 'MacRomanEncoding', '$enc.BaseEncoding';

my $objr-ast = :ind-obj[6, 0, :dict{ :Type( :name<OBJR> ), :Pg( :ind-ref[6, 1] ), :Obj( :ind-ref[6, 2]) } ];
my $objr-ind-obj = PDF::Storage::IndObj.new( |%($objr-ast) );
my $objr-obj = $objr-ind-obj.object;
isa-ok $objr-obj, ::('PDF::DOM::Type::OBJR');
is $objr-obj.Type, 'OBJR', '$objr.Type';
is-deeply $objr-obj<Pg>, (:ind-ref[6, 1]), '$objr<P>';
is-deeply $objr-obj<Obj>, (:ind-ref[6, 2]), '$objr<Obj>';

$input = q:to"--END--";
99 0 obj
<< /Type /OutputIntent  % Output intent dictionary
/S /GTS_PDFX
/OutputCondition (CGATS TR 001 (SWOP))
/OutputConditionIdentifier (CGATS TR 001)
/RegistryName (http://www.color.org)
/DestOutputProfile 100 0 R
>>
endobj
--END--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
$ast = $/.ast;

$ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $oi-font-obj = $ind-obj.object;
isa-ok $oi-font-obj, ::('PDF::DOM::Type::OutputIntent');
is $oi-font-obj.S, 'GTS_PDFX', 'OutputIntent S';
is $oi-font-obj.OutputCondition, 'CGATS TR 001 (SWOP)', 'OutputIntent OutputCondition';
is $oi-font-obj.RegistryName, 'http://www.color.org', 'OutputIntent RegistryName';

use PDF::DOM::Type::Page;
use PDF::DOM::Type::XObject::Form;
use PDF::DOM::Type::XObject::Image;
my $new-page = PDF::DOM::Type::Page.new;
my $form1 = PDF::DOM::Type::XObject::Form.new( :dict{ :BBox[0, 0, 100, 120] } );
my $fm1 = $new-page.resource( $form1 );
is-deeply $fm1.key, 'Fm1', 'xobject form name';

my $form2 = PDF::DOM::Type::XObject::Form.new( :dict{ :BBox[-3, -3, 103, 123] } );
my $image = PDF::DOM::Type::XObject::Image.new( :dict{ :ColorSpace( :name<DeviceRGB> ), :Width(120), :Height(150) } );
my $font = PDF::DOM::Type::Font.new;
my $fm2 = $new-page.resource( $form2 );
is-deeply $fm2.key, 'Fm2', 'xobject form name';

my $im1 = $new-page.resource( $image );
is-deeply $im1.key, 'Im1', 'xobject form name';

my $f1 = $new-page.resource( $font );
is-deeply $f1.key, 'F1', 'font name';

is-json-equiv $new-page<Resources><XObject>, { :Fm1($form1), :Fm2($form2), :Im1($image) }, 'Resource XObject content';
is-json-equiv $new-page<Resources><Font>, { :F1($font) }, 'Resource Font content';

$input = q:to"--END--";
35 0 obj    % Graphics state parameter dictionary
<< /Type /ExtGState
/OP false
/TR 36 0 R
>>
endobj
--END--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
$ast = $/.ast;

$ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $gs-obj = $ind-obj.object;
isa-ok $gs-obj, ::('PDF::DOM::Type::ExtGState');
is $gs-obj.Type, 'ExtGState', 'ExtGState Type';
is-deeply $gs-obj.OP, False, 'ExtGState.OP';
dies-ok {$gs-obj<OP> = 42}, 'Typechecking on assignment';
is-deeply $gs-obj.OP, False, 'ExtGState.OP';
$gs-obj<OP> = False;
lives-ok {$gs-obj<OP> = True}, 'Valid property assignment';
is-deeply $gs-obj.OP, True, 'ExtGState.OP after assignment';
is $gs-obj.TR, (:ind-ref[36, 0]), 'ExtGState TR';

my $gs1 = $new-page.resource( $gs-obj );
is-deeply $gs1.key, 'Eg1', 'ExtGState resource entry';

use PDF::DOM::Array::ColorSpace::Lab;
my $colorspace = PDF::DOM::Array::ColorSpace::Lab.new;
isa-ok $colorspace, PDF::DOM::Array::ColorSpace::Lab;
my $cs1 = $new-page.resource( $colorspace );
is $cs1.key, 'Cs1', 'ColorSpace resource entry';

use PDF::DOM::Type::Shading::Axial;
my $shading = PDF::DOM::Type::Shading::Axial.new( :dict{ :ColorSpace( :name<DeviceRGB> ) } );
my $sh1 = $new-page.resource( $shading );
is $sh1.key, 'Sh1', 'Shading resource entry';

use PDF::DOM::Type::Pattern::Shading;
my $pat-obj = PDF::DOM::Type::Pattern::Shading.new( :dict{ :PaintType(1), :TilingType(2), :Shading{ :ShadingType(2), :ColorSpace( :name<DeviceRGB> ) } } );
my $pt1 = $new-page.resource( $pat-obj );
is $pt1.key, 'Pt1', 'Shading resource entry';

is-json-equiv $new-page.Resources, {
    :ExtGState({:Eg1($gs-obj)}),
    :ColorSpace{:Cs1($colorspace)},
    :Pattern{ :Pt1($pat-obj) },
    :Shading({:Sh1($shading)}),
    :XObject({:Fm1($form1),
	      :Fm2($form2),
	      :Im1($image)}),
    :Font({:F1($font)}),
}, 'Resources';
