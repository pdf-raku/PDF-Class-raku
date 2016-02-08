use v6;
use Test;
use PDF::Doc;
use PDF::Doc::Delegator;

plan 14;

isa-ok PDF::Doc::Delegator.delegate( :dict{ :Type<Page> }), ::('PDF::Doc::Type::Page'), 'delegation sanity';
isa-ok PDF::Doc::Delegator.delegate( :dict{ :Type<XObject>, :Subtype<Image> }), ::('PDF::Doc::Type::XObject::Image'), 'delegation to subclass';
isa-ok PDF::Doc::Delegator.delegate( :dict{ :ShadingType(7) }),  ::('PDF::Doc::Type::Shading::Tensor'), 'delegation by ShadingType';
isa-ok PDF::Doc::Delegator.delegate( :dict{ :ShadingType(42) }),  ::('PDF::Doc::Type::Shading'), 'delegation by ShadingType (unknown)';
isa-ok PDF::Doc::Delegator.delegate( :dict{ :Type<Unknown> }, :fallback(Hash)), Hash, 'delegation fallback';
isa-ok PDF::Doc::Delegator.delegate( :dict{ :FunctionType(3) }),  ::('PDF::Doc::Type::Function::Stitching'), 'delegation by FunctionType';

isa-ok PDF::Doc::Delegator.delegate( :dict{ :Subtype<Link> }),  ::('PDF::Doc::Type::Annot::Link'), 'annot defaulted /Type - implemented';
require ::('PDF::Doc::Type::Annot');
isa-ok PDF::Doc::Delegator.delegate( :dict{ :Subtype<Caret> }, ),  ::('PDF::Doc::Type::Annot'), 'annot defaulted /Type - unimplemented';

require ::('PDF::Doc::Type::Pages');
my $pages = ::('PDF::Doc::Type::Pages').new;
is $pages.Type, 'Pages', '$.Type init';

require ::('PDF::Doc::Type::XObject::Form');
my $form = ::('PDF::Doc::Type::XObject::Form').new( :dict{ :BBox[0, 0, 100, 140 ] } );
is $form.Type, 'XObject', '$.Type init';
is $form.Subtype, 'Form', '$.Subtype init';

require ::('PDF::Doc::Type::Shading::Radial');
my $shading = ::('PDF::Doc::Type::Shading::Radial').new( :dict{ :ColorSpace(:name<DeviceRGB>),
								:Function(:ind-ref[15, 0]),
								:Coords[ 0.0, 0.0, 0.096, 0.0, 0.0, 1.0, 0],
							 } );
is $shading.ShadingType, 3, '$.ShadingType init';

require ::('PDF::Doc::Type::Function::PostScript');
my $function;
lives-ok { $function = ::('PDF::Doc::Type::Function::PostScript').new( :dict{ :Domain[-1, 1, -1, 1] } )}, "PostScript require";
lives-ok {$function.FunctionType}, 'FunctionType accessor';
