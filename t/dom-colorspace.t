use v6;
use Test;

plan 34;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
16 0 obj  % Alternate color space for DeviceN space
[ /CalRGB << /WhitePoint [ 1.0 1.0 1.0 ] >> ]
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 16, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $color-space-obj = $ind-obj.object;
isa-ok $color-space-obj, ::('PDF::DOM::Type')::('ColorSpace::CalRGB');
is $color-space-obj.type, 'ColorSpace', '$.type accessor';
is $color-space-obj.subtype, 'CalRGB', '$.subtype accessor';
is-json-equiv $color-space-obj[1], { :WhitePoint[ 1.0, 1.0, 1.0 ] }, 'array access';
is-json-equiv $color-space-obj[1]<WhitePoint>, [ 1.0, 1.0, 1.0 ], 'WhitePoint dereference';
is-json-equiv $color-space-obj.WhitePoint, $color-space-obj[1]<WhitePoint>, '$WhitePoint accessor';
is-json-equiv $ind-obj.ast, $ast, 'ast regeneration';

require ::('PDF::DOM::Type')::('ColorSpace::CalGray');
my $cal-gray = ::('PDF::DOM::Type')::('ColorSpace::CalGray').new;
isa-ok $cal-gray, ::('PDF::DOM::Type')::('ColorSpace::CalGray'), 'new CS class';
is $cal-gray.subtype, 'CalGray', 'new CS subtype';
isa-ok $cal-gray[1], Hash, 'new CS Dict';

$input = q:to"--END-OBJ--";
10 0 obj
  [/ICCBased << /N 3 /Alternate /DeviceRGB >>]
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
$ast = $/.ast;
$ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 10, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
$color-space-obj = $ind-obj.object;
isa-ok $color-space-obj, ::('PDF::DOM::Type')::('ColorSpace::ICCBased');
is $color-space-obj.type, 'ColorSpace', '$.type accessor';
is $color-space-obj.subtype, 'ICCBased', '$.subtype accessor';
is $color-space-obj.N, 3, 'N accessor';
is $color-space-obj.Alternate, 'DeviceRGB', 'DeviceRGB accessor';

$input = q:to"--END-OBJ--";
11 0 obj
  [ /Indexed /DeviceRGB 255
    < 000000 FF0000 00FF00 0000FF B57342 >
  ]
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
$ast = $/.ast;
$ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 11, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
$color-space-obj = $ind-obj.object;
isa-ok $color-space-obj, ::('PDF::DOM::Type')::('ColorSpace::Indexed');
is $color-space-obj.type, 'ColorSpace', '$.type accessor';
is $color-space-obj.subtype, 'Indexed', '$.subtype accessor';
is $color-space-obj.Base, 'DeviceRGB', 'Base accessor';
is $color-space-obj.Lookup, "\x[00]\x[00]\x[00]\x[FF]\x[00]\x[00]\x[00]\x[FF]\x[00]\x[00]\x[00]\x[FF]\x[B5]\x[73]\x[42]", 'Lookup accessor';

$input = q:to"--END-OBJ--";
5 0 obj  % Color space
[ /Separation
  /LogoGreen
  /DeviceCMYK
  12 0 R
]
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
$ast = $/.ast;
$ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 5, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
$color-space-obj = $ind-obj.object;
isa-ok $color-space-obj, ::('PDF::DOM::Type')::('ColorSpace::Separation');
is $color-space-obj.type, 'ColorSpace', '$.type accessor';
is $color-space-obj.subtype, 'Separation', '$.subtype accessor';
is $color-space-obj.Name, 'LogoGreen', 'Name accessor';
is $color-space-obj.AlternateSpace, 'DeviceCMYK', 'AlternateSpace accessor';
is-json-equiv $color-space-obj.TintTransform, (:ind-ref[12, 0]), 'TintTransform accessor';


