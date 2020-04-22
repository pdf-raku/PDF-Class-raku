use v6;

use PDF::COS::Dict;
use PDF::Class::Type;
use PDF::Content::Resourced;

#| /Type /Catalog - usually the document root in a PDF
class PDF::Catalog
    is PDF::COS::Dict
    does PDF::Class::Type
    does PDF::Content::Resourced {

    # use ISO_32000::Table_28-Entries_in_the_catalog_dictionary;
    # also does ISO_32000::Table_28-Entries_in_the_catalog_dictionary;

    use PDF::COS::Tie;
    use PDF::COS::Tie::Hash;
    use PDF::COS::Name;
    use PDF::COS::Null;
    use PDF::COS::Stream;
    use PDF::COS::TextString;

    use PDF::AdditionalActions;
    use PDF::NumberTree;
    use PDF::NameTree;
    use PDF::Destination :DestSpec, :DestNamed, :coerce-dest;
    use PDF::ViewerPreferences;
    use PDF::Outlines;
    use PDF::Action;
    use PDF::AcroForm;
    use PDF::OutputIntent;
    use PDF::Resources;
    use PDF::Metadata::XML;
    use PDF::Names;
    use PDF::Signature;
    use PDF::Bead-Thread; # Declares PDF::Bead & PDF::Thread
    use PDF::Class::Util :to-roman, :alpha-number, :decimal-number;

    has PDF::COS::Name $.Type is entry(:required, :alias<type>) where 'Catalog';

    has PDF::COS::Name $.Version is entry;               # (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)
    has Hash $.Extensions is entry;

    my subset PagesLike of PDF::Class::Type where { .<Type> ~~ 'Pages' }; # autoloaded PDF::Pages
    has PagesLike $.Pages is entry(:required, :indirect);    # (Required; must be an indirect reference) The page tree node that is the root of the document’s page tree

    role PageLabelNode does PDF::COS::Tie::Hash {
        # use ISO_32000::Table_159-Entries_in_a_page_label_dictionary;
        # also does ISO_32000::Table_159-Entries_in_a_page_label_dictionary;

        has PDF::COS::Name $.Type is entry where 'PageLabel'; # (Optional) The type of PDF object that this dictionary describes; if present, shall be PageLabel for a page label dictionary.
        my subset NumberingStyle of PDF::COS::Name where 'D'|'R'|'r'|'A'|'a';
        has NumberingStyle $.S is entry(:alias<numbering-style>); # (Optional) The numbering style that shall be used for the numeric portion of each page label:
        # D: Decimal arabic numerals
        # R: Uppercase roman numerals
        # r: Lowercase roman numerals
        # A: Uppercase letters (A to Z for the first 26 pages, AA to ZZ for the next 26, and so on)
        # a: Lowercase letters (a to z for the first 26 pages, aa to zz for the next 26, and so on)
        # There is no default numbering style; if no S entry is present, page labels consist solely of a label prefix with no numeric portion.
        has PDF::COS::TextString $.P is entry(:alias<prefix>); # (Optional) The label prefix for page labels in this range.
        has UInt $.St is entry(:alias<start>); # (Optional) The value of the numeric portion for the first page label in the range.
    }

    role PageLabels does PDF::NumberTree[PageLabelNode] {
        has Array $.nums;
        method nums {
            $!nums //= [ self.number-tree.Hash.pairs.sort ];
        }

        multi sub page-num('D', UInt $seq) { decimal-number($seq) }
        multi sub page-num('R', UInt $seq) { to-roman($seq) }
        multi sub page-num('r', UInt $seq) { to-roman($seq).lc }
        multi sub page-num('A', UInt $seq) { alpha-number($seq) }
        multi sub page-num('a', UInt $seq) { alpha-number($seq).lc }
        multi sub page-num($_,   UInt $seq) is default {
            warn "unknown page-label type: $_";
            decimal-number($seq)
        }

        #| page indices, starting at zero
        method AT-POS(Int() $page-idx) {
            my Pair $num = $.nums.grep(*.key <= $page-idx).tail;
            my UInt $base  = $num.key;
            my PageLabelNode $props = $num.value;
            my UInt $start = $props.start // 1;
            my UInt $seq   = $page-idx + $start - $base;
            my $label      = $props.prefix // '';
            $label ~= page-num($_, $seq)
                with $props.numbering-style;
            $label;
        }
        #| page labels, starting at page 1
        method page-label(UInt $page-num) {
            self[$page-num - 1];
        }
    }
    has PageLabels $.PageLabels is entry;           # (Optional; PDF 1.3) A number tree defining the page labeling for the document.

    has PDF::Names $.Names is entry;        # (Optional; PDF 1.2) The document’s name dictionary

    has DestNamed %.Dests is entry(:coerce(&coerce-dest));    # (Optional; PDF 1.1; must be an indirect reference) A dictionary of names and corresponding destinations

    has PDF::ViewerPreferences $.ViewerPreferences is entry; # (Optional; PDF 1.2) A viewer preferences dictionary specifying the way the document is to be displayed on the screen.

    subset PageLayout of PDF::COS::Name where 'SinglePage'|'OneColumn'|'TwoColumnLeft'|'TwoColumnRight'|'TwoPageLeft'|'TwoPageRight';
    has PageLayout $.PageLayout is entry;                    # (Optional) A name object specifying the page layout to be used when the document is opened

    subset PageMode of PDF::COS::Name where 'UseNone'|'UseOutlines'|'UseThumbs'|'FullScreen'|'UseOC'|'UseAttachments';
    has PageMode $.PageMode is entry;                        # (Optional) A name object specifying how the document should be displayed when opened

    has PDF::Outlines $.Outlines is entry(:indirect); # (Optional; must be an indirect reference) The outline dictionary that is the root of the document’s outline hierarchy

    has PDF::Thread @.Threads is entry(:indirect);        # (Optional; PDF 1.1; must be an indirect reference) An array of thread dictionaries representing the document’s article threads

    my subset OpenAction where PDF::Action|DestSpec;
    multi sub coerce-action(List $_ is rw, OpenAction) {
        coerce-dest($_, DestSpec);
    }
    multi sub coerce-action($_, OpenAction) is default {
        fail "unable to coerce {.perl} to an open action";
    }
    has OpenAction $.OpenAction is entry(:coerce(&coerce-action));    # (Optional; PDF 1.1) A value specifying a destination to be displayed or an action to be performed when the document is opened.

    has PDF::AdditionalActions $.AA is entry(:alias<additional-actions>);           # (Optional; PDF 1.4) An additional-actions dictionary defining the actions to be taken in response to various trigger events affecting the document as a whole

    role URI does PDF::COS::Tie::Hash {
        # use ISO_32000::Table_207-Entry_in_a_URI_dictionary;
        # also does ISO_32000::Table_207-Entry_in_a_URI_dictionary;
        has PDF::COS::ByteString $.Base is entry;           # (Optional) The base URI that shall be used in resolving relative URI references. URI actions within the document may specify URIs in partial form, to be interpreted relative to this base address. If no base URI is specified, such partial URIs shall be interpreted relative to the location of the document itself. The use of this entry is parallel to that of the body element <BASE >, as described in the HTML 4.01 Specification
    }
    has URI $.URI is entry;                 # (Optional; PDF 1.1) A URI dictionary containing document-level information for URI

    has PDF::AcroForm $.AcroForm is entry;                  # (Optional; PDF 1.2) The document’s interactive form (AcroForm) dictionary

    has PDF::Metadata::XML $.Metadata is entry(:indirect);  # (Optional; PDF 1.4; must be an indirect reference) A metadata stream containing metadata for the document

    my subset StructTreeLike of PDF::Class::Type where { .<Type> ~~ 'StructTreeRoot' }; # autoloaded PDF::StructTreeRoot
    has StructTreeLike $.StructTreeRoot is entry;           # (Optional; PDF 1.3) The document’s structure tree root dictionary

    role MarkInfoDict
	does PDF::COS::Tie::Hash {

        # use ISO_32000::Table_321-Entries_in_the_mark_information_dictionary;
        # also does ISO_32000::Table_321-Entries_in_the_mark_information_dictionary;
	has Bool $.Marked is entry;          # (Optional) A flag indicating whether the document conforms to Tagged PDF conventions. Default value: false.
					     # Note: If Suspects is true, the document may not completely conform to Tagged PDF conventions.
	has Bool $.UserProperties is entry;  # (Optional; PDF 1.6) A flag indicating the presence of structure elements that contain user properties attributes. Default value: false.
	has Bool $.Suspects is entry;        # Optional; PDF 1.6) A flag indicating the presence of tag suspects. Default value: false.
    }

    has MarkInfoDict $.MarkInfo is entry;                # (Optional; PDF 1.4) A mark information dictionary containing information about the document’s usage of Tagged PDF conventions

    has PDF::COS::TextString $.Lang is entry;            # (Optional; PDF 1.4) A language identifier specifying the natural language for all text in the document except where overridden by language specifications for structure elements or marked content

    has PDF::COS::Dict $.SpiderInfo is entry;            # (Optional; PDF 1.3) A Web Capture information dictionary containing state information used by the Acrobat Web Capture (AcroSpider) plug-in extension

    has PDF::OutputIntent @.OutputIntents is entry;      # (Optional; PDF 1.4) An array of output intent dictionaries describing the color characteristics of output devices on which the document might be rendered

    has PDF::COS::Dict $.PieceInfo is entry;             # (Optional; PDF 1.4) A page-piece dictionary associated with the document

    my subset OCGLike of PDF::Class::Type where { .<Type> ~~ 'OCG' }; # autoloaded PDF::OCG (Optional Content Group)

    role OCConfig
	does PDF::COS::Tie::Hash {
        # use ISO_32000::Table_101-Entries_in_an_Optional_Content_Configuration_Dictionary;
        # also does ISO_32000::Table_101-Entries_in_an_Optional_Content_Configuration_Dictionary;
        has PDF::COS::TextString $.Name is entry; # (Optional) A name for the configuration, suitable for presentation in a user interface.
        has PDF::COS::TextString $.Creator is entry; # (Optional) Name of the application or feature that created thisconfiguration dictionary.
        my subset BaseState of PDF::COS::Name where 'ON'|'OFF'|'Unchanged';
        has BaseState $.BaseState is entry; # (Optional) Used to initialize the states of all the optional content groups in a document when this configuration is applied. The value of this entry shall be one of the following names:
        has OCGLike @.ON is entry;  # (Optional) An array of optional content groups whose state shall be set to ON when this configuration is applied. If the BaseState entry is ON, this entry is redundant.
        has OCGLike @.OFF is entry; # (Optional) An array of optional content groups whose state shall be set to OFF when this configuration is applied. If the BaseState entry is OFF, this entry is redundant.
        has PDF::COS::Name @.Intent is entry(:array-or-item); # name or array (Optional) A single intent name or an array containing any combination of names.
        has @.AS is entry; # (Optional) An array of usage application dictionaries.
        has @.Order is entry; # array (Optional) An array specifying the order for presentation of optional content groups in a conforming reader’s user interface.
        my subset ListMode of PDF::COS::Name where 'AllPages'|'VisiblePages';
        has ListMode $.ListMode is entry; # (Optional) A name specifying which optional content groups in the Order array shall be displayed to the user.
        has @.RBGroups is entry; # (Optional) An array consisting of one or more arrays, each of which represents a collection of optional content groups whose states shall be intended to follow a radio button paradigm. That is, the state of at most one optional content group in each array shall be ON at a time. If one group is turned ON, all others shall be turned OFF.
       has OCGLike @.Locked is entry; # (Optional; PDF 1.6) An array of optional content groups that shall be locked when this configuration is applied.
}

    role OCProperties
	does PDF::COS::Tie::Hash {
        # use ISO_32000::Table_100-Entries_in_the_Optional_Content_Properties_Dictionary;
        # also does ISO_32000::Table_100-Entries_in_the_Optional_Content_Properties_Dictionary;
        has OCGLike @.OCGs is entry(:indirect, :required, :alias<optional-content-groups>); # (Required) An array of indirect references to all the optional content groups in the document, in any order. Every optional content group shall be included in this array
        has PDF::COS::Dict $.D is entry(:required, :alias<viewing-config>); # (Required) The default viewing optional content configuration dictionary.
        has OCConfig @.Configs is entry;    # (Optional) An array of alternate optional content configuration dictionaries.
    }
    has OCProperties $.OCProperties is entry;   # (Optional; PDF 1.5; required if a document contains optional content) The document’s optional content properties dictionary

    role Permissions
	does PDF::COS::Tie::Hash {
        # use ISO_32000::Table_258-Entries_in_a_permissions_dictionary;
        # also does ISO_32000::Table_258-Entries_in_a_permissions_dictionary;
        has PDF::Signature $.DocMDP is entry(:indirect); # (Optional) An indirect reference to a signature dictionary (see Table 252). This dictionary shall contain a Reference entry that is a signature reference dictionary (see Table 252) that has a DocMDP transform method (see 12.8.2.2, “DocMDP”) and corresponding transform parameters.
        has PDF::Signature $.UR3 is entry;               # (Optional) A signature dictionary that is used to specify and validate additional capabilities (usage rights) granted for this document; that is, the enabling of interactive features of the conforming reader that are not available by default.
    }
    has Permissions $.Perms is entry;           # (Optional; PDF 1.5) A permissions dictionary that specifies user access permissions for the document.

    has PDF::COS::Dict $.Legal is entry;        # (Optional; PDF 1.5) A dictionary containing attestations regarding the content of a PDF document, as it relates to the legality of digital signatures

    has PDF::COS::Dict @.Requirements is entry; # (Optional; PDF 1.7) An array of requirement dictionaries representing requirements for the document.

    has PDF::COS::Dict $.Collection is entry;   # (Optional; PDF 1.7) A collection dictionary that a PDF consumer uses to enhance the presentation of file attachments stored in the PDF document.

    has Bool $.NeedsRendering is entry;         # (Optional; PDF 1.7) A flag used to expedite the display of PDF documents containing XFA forms. It specifies whether the document must be regenerated when the document is first opened.

    has PDF::Resources $.Resources is entry;

    method cb-init {
        # vivify pages root
	self<Type> //= PDF::COS.coerce( :name<Catalog> );

        self<Pages> //= PDF::COS.coerce(
            :dict{
                :Type( :name<Pages> ),
                :Resources{ :ProcSet[ :name<PDF>, :name<Text> ] },
                :Count(0),
                :Kids[],
	    });
    }

    method cb-finish {
        .is-indirect ||= True with self<Dests>;
        self<Pages>.?cb-finish;

        # flush any name/number tree updates
        .cb-finish() with .<Names>;
        .cb-finish() with .<PageLabels>;

        with self<StructTreeRoot> {
            .cb-finish() with .<IDTree>;
            .cb-finish() with .<ParentTree>;
        }
    }
}

