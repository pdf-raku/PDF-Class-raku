use v6;
use PDF::DOM::Type::Font;

class PDF::DOM::Type::Font::Type0
    is PDF::DOM::Type::Font {
	use PDF::Object::Tie;
	use PDF::Object::Name;
	use PDF::Object::Stream;
	# see [ PDF 1.7 TABLE 5.18 Entries in a Type 0 font dictionary]
	has PDF::Object::Name $.BaseFont is entry(:required); #| (Required) The PostScript name of the font. In principle, this is an arbitrary name, since there is no font program associated directly with a Type 0 font dictionary.
	subset NameOrStream of Any where PDF::Object::Name | PDF::Object::Stream;
        has NameOrStream $.Encoding is entry(:required);      #| (Required) The name of a predefined CMap, or a stream containing a CMap that maps character codes to font numbers and CIDs.
	has Array $.DescendantFonts is entry(:required);      #| (Required) A one-element array specifying the CIDFont dictionary that is the descendant of this Type 0 font.
        has PDF::Object::Stream $.ToUnicode is entry;         #| (Optional) A stream containing a CMap file that maps character codes to Unicode values
}
