use v6;
use Test;

plan 10;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
16 0 obj% Alternate color space for DeviceN space
[ /CalRGB
<< /WhitePoint [ 1.0 1.0 1.0 ] >>
]
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast);
is $ind-obj.obj-num, 16, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $color-space-obj = $ind-obj.object;
isa-ok $color-space-obj, ::('PDF::DOM::Array')::('ColorSpace::CalRGB');
is $color-space-obj.type, 'ColorSpace', '$.type accessor';
is $color-space-obj.subtype, 'CalRGB', '$.subtype accessor';
is-json-equiv $color-space-obj.dict, { :WhitePoint[ 1.0, 1.0, 1.0 ] }, '$.dict accessor';
is-deeply $ind-obj.ast, $ast, 'ast regeneration';

require ::('PDF::DOM::Array')::('ColorSpace::CalGray');
my $cal-gray = ::('PDF::DOM::Array')::('ColorSpace::CalGray').new;
isa-ok $cal-gray, ::('PDF::DOM::Array')::('ColorSpace::CalGray'), 'CalGray from scratch';
is $cal-gray.subtype, 'CalGray', 'CalGray from scratch';
isa-ok $cal-gray.dict, Hash, 'CalGray from scratch';
