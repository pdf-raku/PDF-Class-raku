use v6;
use Test;
use PDF::Struct::Doc;
use PDF::Struct::Doc::Delegator;

plan 15;

isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :Type<Page> }), ::('PDF::Struct::Page'), 'delegation sanity';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :Type<XObject>, :Subtype<Image> }), ::('PDF::Struct::XObject::Image'), 'delegation to subclass';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :ShadingType(7) }),  ::('PDF::Struct::Shading::Tensor'), 'delegation by ShadingType';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :ShadingType(42) }),  ::('PDF::Struct::Shading'), 'delegation by ShadingType (unknown)';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :Type<Unknown> }, :fallback(Hash)), Hash, 'delegation fallback';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :FunctionType(3) }),  ::('PDF::Struct::Function::Stitching'), 'delegation by FunctionType';

isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :Subtype<Link> }),  ::('PDF::Struct::Annot::Link'), 'annot defaulted /Type - implemented';
require ::('PDF::Struct::Annot');
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :Subtype<Caret> }, ),  ::('PDF::Struct::Annot'), 'annot defaulted /Type - unimplemented';
isa-ok PDF::Struct::Doc::Delegator.delegate( :dict{ :S<GTS_PDFX> }, ),  ::('PDF::Struct::OutputIntent'), 'output intent defaulted /Type';

require ::('PDF::Struct::Pages');
my $pages = ::('PDF::Struct::Pages').new;
is $pages.Type, 'Pages', '$.Type init';

require ::('PDF::Struct::XObject::Form');
my $form = ::('PDF::Struct::XObject::Form').new( :dict{ :BBox[0, 0, 100, 140 ] } );
is $form.Type, 'XObject', '$.Type init';
is $form.Subtype, 'Form', '$.Subtype init';

require ::('PDF::Struct::Shading::Radial');
my $shading = ::('PDF::Struct::Shading::Radial').new( :dict{ :ColorSpace(:name<DeviceRGB>),
								:Function(:ind-ref[15, 0]),
								:Coords[ 0.0, 0.0, 0.096, 0.0, 0.0, 1.0, 0],
							 } );
is $shading.ShadingType, 3, '$.ShadingType init';

require ::('PDF::Struct::Function::PostScript');
my $function;
lives-ok { $function = ::('PDF::Struct::Function::PostScript').new( :dict{ :Domain[-1, 1, -1, 1] } )}, "PostScript require";
lives-ok {$function.FunctionType}, 'FunctionType accessor';
