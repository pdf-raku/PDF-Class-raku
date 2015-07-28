use v6;
use Test;
use PDF::DOM;
use PDF::DOM::Delegator;

plan 12;

isa-ok PDF::DOM::Delegator.delegate( :dict{ :Type<Page> }), ::('PDF::DOM::Type::Page'), 'delegation sanity';
isa-ok PDF::DOM::Delegator.delegate( :dict{ :Type<XObject> :Subtype<Image> }), ::('PDF::DOM::Type::XObject::Image'), 'delegation to subclass';
isa-ok PDF::DOM::Delegator.delegate( :dict{ :ShadingType(7) }),  ::('PDF::DOM::Type::Shading::Tensor'), 'delegation by ShadingType';
isa-ok PDF::DOM::Delegator.delegate( :dict{ :ShadingType(42) }),  ::('PDF::DOM::Type::Shading'), 'delegation by ShadingType (unknown)';
isa-ok PDF::DOM::Delegator.delegate( :dict{ :Type<Unknown> }, :fallback(Hash)), Hash, 'delegation fallback';
isa-ok PDF::DOM::Delegator.delegate( :dict{ :FunctionType(3) }),  ::('PDF::DOM::Type::Function::Stitching'), 'delegation by FunctionType';

require ::('PDF::DOM::Type::Pages');
my $pages = ::('PDF::DOM::Type::Pages').new;
is $pages.Type, 'Pages', '$.Type init';

require ::('PDF::DOM::Type::XObject::Form');
my $form = ::('PDF::DOM::Type::XObject::Form').new( :dict{ :BBox[0, 0, 100, 140 ] } );
is $form.Type, 'XObject', '$.Type init';
is $form.Subtype, 'Form', '$.Subtype init';

require ::('PDF::DOM::Type::Shading::Radial');
my $shading = ::('PDF::DOM::Type::Shading::Radial').new( :dict{ :ColorSpace(:name<DeviceRGB>),
								:Function(:ind-ref[15, 0]),
								:Coords[ 0.0, 0.0, 0.096, 0.0, 0.0, 1.0, 0],
							 } );
is $shading.ShadingType, 3, '$.ShadingType init';

require ::('PDF::DOM::Type::Function::PostScript');
my $function;
lives-ok { $function = ::('PDF::DOM::Type::Function::PostScript').new( :dict{ :Domain[-1, 1, -1, 1] } )}, "PostScript require";
lives-ok {$function.FunctionType}, 'FunctionType accessor';
