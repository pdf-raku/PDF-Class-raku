use v6;
use Test;

use PDF::DOM;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Storage::IndObj;

my $input = q:to"--END--";
1 0 obj
<< /FT /Btn
   /T ( Urgent )
   /V /Yes
   /AS /Yes
   /AP << /N << /Yes 2 0 R /Off 3 0 R>>
>>
endobj
--END--

my $actions = PDF::Grammar::PDF::Actions.new;
PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed: $input";
my $ast = $/.ast;

my $ind-obj = PDF::Storage::IndObj.new( :$input, |%( $ast.kv ) );
my $cmap-obj = $ind-obj.object;
isa-ok $cmap-obj, ::('PDF::DOM::Type::Field');
is $cmap-obj.type, 'Field', 'Field type';
is $cmap-obj.CMapName, '90ms-RKSJ-H', 'CMapName';
isa-ok $cmap-obj.CIDSystemInfo, ::('PDF::DOM::Type::CIDSystemInfo');
like $cmap-obj.decoded, rx/^'%!PS-Adobe-3.0 Resource-CMap'/, 'CMap stream content';

done-testing;