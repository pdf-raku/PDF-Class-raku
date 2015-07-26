use v6;

use PDF::Object::Dict;
use PDF::DOM::Type;
use PDF::DOM::Resources;

# /Type /Catalog - usually the document root in a PDF
# See [PDF 1.7 Section 3.6.1 Document Catalog]
class PDF::DOM::Type::Catalog
    is PDF::Object::Dict
    does PDF::DOM::Type
    does PDF::DOM::Resources {

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::Object::Tie;
    use PDF::Object::Array;
    use PDF::Object::Bool;
    use PDF::Object::Dict;
    use PDF::Object::Name;
    use PDF::Object::Stream;

    has PDF::Object::Name $!Version is entry;                #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)

    use PDF::Object::Tie;
    use PDF::DOM::Type::Pages;
    has PDF::DOM::Type::Pages $!Pages is entry(:required);  #| (Required; must be an indirect reference) The page tree node that is the root of the document’s page tree

    #tba distinct number tree objects
    has PDF::Object::Dict $!PageLabels is entry;            #| (Optional; PDF 1.3) A number tree defining the page labeling for the document.

    has PDF::Object::Dict $!Names is entry;                 #| (Optional; PDF 1.2) The document’s name dictionary

    has PDF::Object::Dict $!Dests is entry;                 #| (Optional; PDF 1.1; must be an indirect reference) A dictionary of names and corresponding destinations

    has PDF::Object::Dict $!ViewPreferences is entry;       #| (Optional; PDF 1.2) A viewer preferences dictionary specifying the way the document is to be displayed on the screen.

    subset PageLayout of PDF::Object::Name where 'SinglePage'|'OneColumn'|'TwoColumnLeft'|'TwoColumnRight'|'TwoPageLeft'|'TwoPageRight';
    has PageLayout $!PageLayout is entry;                   #| (Optional) A name object specifying the page layout to be used when the document is opened

    subset PageMode of PDF::Object::Name where 'UseNone'|'UseOutlines'|'UseThumbs'|'FullScreen'|'UseOC'|'UseAttachments';
    has PageMode $!PageMode is entry;                       #| (Optional) A name object specifying how the document should be displayed when opened

    use PDF::DOM::Type::Outlines;
    has PDF::DOM::Type::Outlines $!Outlines is entry;       #| (Optional; must be an indirect reference) The outline dictionary that is the root of the document’s outline hierarchy

    has PDF::Object::Array $!Threads is entry;              #| (Optional; PDF 1.1; must be an indirect reference) An array of thread dictionaries representing the document’s article threads

    subset ArrayOrDict of PDF::Object where PDF::Object::Array|PDF::Object::Dict;
    has ArrayOrDict $!OpenAction is entry;                  #| (Optional; PDF 1.1) A value specifying a destination to be displayed or an action to be performed when the document is opened.

    has PDF::Object::Dict $!AA is entry;                    #| (Optional; PDF 1.4) An additional-actions dictionary defining the actions to be taken in response to various trigger events affecting the document as a whole

    has PDF::Object::Dict $!URI is entry;                   #| (Optional; PDF 1.1) A URI dictionary containing document-level information for URI

    has PDF::Object::Dict $!AcroForm is entry;              #| (Optional; PDF 1.2) The document’s interactive form (AcroForm) dictionary

    has PDF::Object::Stream $!Metadata is entry;            #| (Optional; PDF 1.4; must be an indirect reference) A metadata streamcontaining metadata for the document

    has PDF::Object::Dict $!StructTreeRoot is entry;        #| (Optional; PDF 1.3) The document’s structure tree root dictionary

    has PDF::Object::Dict $!MarkInfo is entry;              #| (Optional; PDF 1.4) A mark information dictionary containing information about the document’s usage of Tagged PDF conventions

    has Str $!Lang is entry;                                #| (Optional; PDF 1.4) A language identifier specifying the natural language for all text in the document except where overridden by language specifications for structure elements or marked content

    has PDF::Object::Dict $!SpiderInfo is entry;            #| (Optional; PDF 1.3) A Web Capture information dictionary containing state information used by the Acrobat Web Capture (AcroSpider) plug-in extension

    has PDF::Object::Array $!OutputIntents is entry;        #| (Optional; PDF 1.4) An array of output intent dictionaries describing the color characteristics of output devices on which the document might be rendered

    has PDF::Object::Dict $!PieceInfo is entry;             #| (Optional; PDF 1.4) A page-piece dictionary associated with the document

    has PDF::Object::Dict $!OCProperties is entry;          #| (Optional; PDF 1.5; required if a document contains optional content) The document’s optional content properties dictionary

    has PDF::Object::Dict $!Perms is entry;                 #| (Optional; PDF 1.5) A permissions dictionary that specifies user access permissions for the document.

    has PDF::Object::Dict $!Legal is entry;                 #| (Optional; PDF 1.5) A dictionary containing attestations regarding the content of a PDF document, as it relates to the legality of digital signatures

    has PDF::Object::Array $!Requirements is entry;         #| (Optional; PDF 1.7) An array of requirement dictionaries representing requirements for the document.

    has PDF::Object::Dict $!Collection is entry;            #| (Optional; PDF 1.7) A collection dictionary that a PDF consumer uses to enhance the presentation of file attachments stored in the PDF document.

    has PDF::Object::Bool $!NeedsRendering is entry;        #| (Optional; PDF 1.7) A flag used to expedite the display of PDF documents containing XFA forms. It specifies whether the document must be regenerated when the document is first opened.

    method cb-finish {
        self<Pages>.cb-finish;
    }

    method new() {
        my $obj = callsame;

        # vivify pages
        $obj<Pages> //= PDF::DOM::Type::Pages.new(
            :dict{
                :Resources{ :Procset[ :name<PDF>, :name<Text> ] },
                :Count(0),
                :Kids[],
                });

        $obj;
    }


}
