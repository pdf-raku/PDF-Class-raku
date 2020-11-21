unit module PDF::Class::Defs;

use PDF::COS;
use PDF::COS::Name;
use PDF::COS::Stream;
use PDF::COS::TextString;
use PDF::ColorSpace;

# See [PDF 32000 Table 169 - Annotation types]
my subset AnnotSubtype of Str
    is export(:AnnotSubtype)
    where 'Text'|'Link'|'FreeText'|'Line'|'Square'|
    'Circle'|'Polygon'|'PolyLine'|'Highlight'|'Underline'|'Squiggly'|'StrikeOut'|
    'Stamp'|'Caret'|'Ink'|'Popup'|'FileAttachment'|'Sound'|'Movie'|'Widget'|'Screen'|
    'PrinterMark'|'TrapNet'|'Watermark'|'3D'|'Redact';

my subset AnnotLike is export(:AnnotLike) of Hash where .<Subtype> ~~ AnnotSubtype;

# See [PDF 32000 Table 198 – Action types]
my subset ActionSubtype of Str
    is export(:ActionSubtype)
    where
    'GoTo'         #| Go to a destination in the current document.
    |'GoToR'       #| (“Go-to remote”) Go to a destination in another document.
    |'GoToE'       #| (“Go-to embedded”; PDF 1.6) Go to a destination in an embedded file.
    |'Launch'      #| Launch an application, usually to open a file.
    |'Thread'      #| Begin reading an article thread.
    |'URI'         #| Resolve a uniform resource identifier.
    |'Sound'       #| (PDF 1.2) Play a sound.
    |'Movie'       #| (PDF 1.2) Play a movie.
    |'Hide'        #| (PDF 1.2) Set an annotation’s Hidden flag.
    |'Named'       #| (PDF 1.2) Execute an action predefined by the viewer application.
    |'SubmitForm'  #| (PDF 1.2) Send data to a uniform resource locator.
    |'ResetForm'   #| (PDF 1.2) Set fields to their default values.
    |'ImportData'  #| (PDF 1.2) Import field values from a file.
    |'JavaScript'  #| (PDF 1.3) Execute a JavaScript script.
    |'SetOCGState' #| (PDF 1.5) Set the states of optional content groups.
    |'Rendition'   #| (PDF 1.5) Controls the playing of multimedia content.
    |'Trans'       #| (PDF 1.5) Updates the display of a document, using a transition dictionary.
    |'GoTo3DView'  #| (PDF 1.6) Set the current view of a 3D annotation
;

my subset FontFileType of Str is export(:FontFileType) where 'Type1C'|'CIDFontType0C'|'OpenType';

my subset TextOrStream is export(:TextOrStream) where PDF::COS::TextString | PDF::COS::Stream;
multi sub coerce-text-or-stream(Str $value is rw, TextOrStream) is export(:TextOrStream) {
    $value = PDF::COS::TextString.COERCE: $value;
}

my subset ColorSpace of PDF::COS is export(:ColorSpace) where PDF::COS::Name | PDF::ColorSpace;
