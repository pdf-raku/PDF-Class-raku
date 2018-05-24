# PDF::Class

PDF files have a reasonably well defined structure and consist largely of standard objects and associated data, including Pages, Fonts, Graphics and many others.

PDF::Class:

- provides a set of roles and classes that map to the structure and objects in PDF documents; the aim being to make it easier to read, write, validate and, in general, grok PDF files.

- assists with navigation and construction of PDF documents, including inheritance (via Parent entries) and the sometimes finicky serialization rules regarding indirect objects. These details are automatically handled to ensure the `save-as` method correctly serializes the PDF.

- is the base class for [PDF::API6](https://github.com/p6-pdf/PDF-API6).

The top level of a PDF document is of type `PDF::Class`. It contains the `PDF::Catalog` in its root entry. Other classes in the document are accessible from the Catalog.

As an example, the following PDF::Lite code:

    use PDF::Lite;
    my PDF::Lite $pdf .= open: "t/helloworld.pdf";
    my Hash $catalog = $pdf<Root>;
    given $catalog<ViewerPreferences> //= {} {
        .<HideToolbar> = True;
    }
    my Hash $new-page = $pdf.add-page;
    #...

Could be more safely and legibly written in PDF::Class as:
```
    use PDF::Class;
    use PDF::Catalog;
    use PDF::Page;

    my PDF::Class $pdf .= open: "t/helloworld.pdf";
    my PDF::Catalog $catalog = $pdf.catalog;
    given $catalog.ViewerPreferences //= {} {
        .HideToolbar = True;
    }
    my PDF::Page $new-page = $pdf.add-page;
    #...
```


- This module contains definitions for many other PDF internal objects, including streams, dictionaries(hashes), arrays and others, as listed below.
- There is generally a one-to-one correspondence between raw dictionary entries and accessors, e.g. `$pdf<Root><AA>` versus `$pdf.Root.AA`.
- There are often accessor aliases, to aide clarity. E.g. `$pdf.Root.AA` can also be written as `$pdf.catalog.additional-actions`.
- The classes often contain additional accessor and helper methods. For example `$pdf.page(10)` - references page 10, without the need to navigate the catalog and page tree.

This module is a work in progress. It currently maps many of the more commonly used PDF objects.

## More examples:

### Set Marked Info options
```
    use PDF::Class;
    use PDF::Catalog;
    my PDF::Class $pdf .= new;
    my PDF::Catalog $catalog = $pdf.catalog;
    with $catalog.MarkInfo //= {} {
        .Marked = True;
        .UserProperties = False;
        .Suspects = False;
    }
```


### Set Page Layout & Viewer Preferences
```
    use PDF::Class;
    use PDF::Catalog;
    my PDF::Class $pdf .= new;

    my PDF::Catalog $doc = $pdf.catalog;
    $doc.PageLayout = 'TwoColumnLeft';
    $doc.PageMode   = 'UseThumbs';

    given $doc.ViewerPreferences //= {} {
        .Duplex = 'DuplexFlipShortEdge';
        .NonFullScreenPageMode = 'UseOutlines';
    }
    # ...etc, see PDF::ViewerPreferences
```

### List AcroForm Fields

```
use PDF::Class;
use PDF::AcroForm;
use PDF::Field;

my PDF::Class $doc .= open: "t/pdf/samples/OoPdfFormExample.pdf";
with my PDF::AcroForm $acroform = $doc.catalog.AcroForm {
    my PDF::Field @fields = $acroform.fields;
    # display field names and values
    for @fields -> $field {
        say "{$field.key}: {$field.value}";
    }
}

```

## Raw Data Access

In general, PDF::Class provides accessors for safe access and update of PDF objects.

However you may choose to bypass these accessors and dereference hashes and arrays directly, giving raw un-typed access to internal data structures:

This will also bypass type coercements, so you may need to be more explicit. In
the following example we cast the PageMode to a name, so it appears as a name
in the out put stream `:name<UseToes>`, rather than a string `'UseToes'`.

```
    use PDF::Class;
    use PDF::Catalog;
    my PDF::Class $pdf .= new;

    my PDF::Catalog $doc = $pdf.catalog;
    try {
        $doc.PageMode   = 'UseToes';
        CATCH { default { say "err, that didn't work: $_" } }
    }

    # same again, bypassing type checking
    $doc<PageMode>  = :name<UseToes>;
```

## Scripts in this Distribution

#### `pdf-append.p6`

appends PDF files

#### `pdf-burst.p6`

bursts a multi-page PDF into single page PDF files

#### `pdf-checker.p6`

validates the internal structure of a PDF.

#### `pdf-info.p6`

prints various PDF properties

#### `pdf-revert.p6`

undoes the last revision of an incrementally saved PDF file.

## Development Status

The PDF::Class module is under construction and not yet functionally complete.

## Classes Quick Reference

Class | Types | Accessors | Methods | Description
------|-------|-----------|---------|------------
PDF::Class | dict | Encrypt, ID, Info, Root(catalog), Size | Pages, ast, crypt, encrypt, open, permitted, save-as, update, version | PDF entry-point. either a trailer dict or an XRef stream
PDF::Catalog | dict | AA(additional-actions), AcroForm, Collection, Dests, Lang, Legal, MarkInfo, Metadata, Names, NeedsRendering, OCProperties, OpenAction, Outlines, OutputIntents, PageLabels, PageLayout, PageMode, Pages, Perms, PieceInfo, Requirements, Resources, SpiderInfo, StructTreeRoot, Threads, Type, URI, Version, ViewerPreferences | core-font, find-resource, images, resource-entry, resource-key, use-font, use-resource | /Type /Catalog - usually the document root in a PDF See [PDF 1.7 Section 3.6.1 Document Catalog]
PDF::AcroForm | dict | CO(calculation-order), DA(default-appearance), DR(default-resources), Fields, NeedAppearances, Q(quadding), SigFlags, XFA | fields, fields-hash | 
PDF::Action::GoTo | dict | D(destination), Next, S, Type |  | /Action Subtype - GoTo
PDF::Action::GoToR | dict | D(destination), NewWindow, Next, S, Type |  | /Action Subtype - GoToR
PDF::Action::Named | dict | N(action-name), Next, S, Type |  | /Action Subtype - GoTo
PDF::Action::URI | dict | Base, IsMap, Next, S, Type, URI |  | /Action Subtype - URI
PDF::Annot::Caret | dict | AP(appearance), AS(appearance-state), Border, C(color), Contents, DR(default-resources), F(flags), M(mod-time), NM(name), OC(optional-content), P(page), RD(rectangle-differences), Rect, StructParent, Subtype, Sy(symbol), Type |  | 
PDF::Annot::Circle | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), IC(interior-color), M(mod-time), NM(name), OC(optional-content), P(page), RD(rectangle-differences), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::FileAttachment | dict | AP(appearance), AS(appearance-state), Border, C(color), Contents, DR(default-resources), F(flags), FS(file-spec), M(mod-time), NM(name), Name(icon-name), OC(optional-content), P(page), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Link | dict | A(action), AP(appearance), AS(appearance-state), BS, Border, C(color), Contents, DR(default-resources), Dest, F(flags), H(highlight-mode), M(mod-time), NM(name), OC(optional-content), P(page), PA(uri-action), QuadPoints, Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Square | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), IC(interior-color), M(mod-time), NM(name), OC(optional-content), P(page), RD(rectangle-differences), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Text | dict | AP(appearance), AS(appearance-state), Border, C(color), Contents, DR(default-resources), F(flags), M(mod-time), NM(name), Name(icon-name), OC(optional-content), Open, P(page), Rect, State, StateModel, StructParent, Subtype, Type |  | /Type Annot - Annonation subtypes See [PDF 1.7 Section 8.4 Annotations]
PDF::Annot::Widget | dict | A(action), AA(additional-actions), AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), H(highlight-mode), M(mod-time), MK, NM(name), OC(optional-content), P(page), Rect, StructParent, Subtype, Type |  | 
PDF::Appearance | dict | D(down), N(normal), R(rollover) |  | 
PDF::Border | dict | D(dash-pattern), S(style), Type, W(width) |  | 
PDF::CIDSystemInfo | dict | Ordering, Registry, Supplement |  | 
PDF::CMap | stream | CIDSystemInfo, CMapName, Type, UseCMap, WMode |  | /Type /CMap
PDF::ColorSpace::CalGray | array | Subtype, dict | BlackPoint, Gamma, WhitePoint | 
PDF::ColorSpace::CalRGB | array | Subtype, dict | BlackPoint, Gamma, Matrix, WhitePoint | 
PDF::ColorSpace::DeviceN | array | AlternateSpace, Attributes, Names, Subtype, TintTransform |  | 
PDF::ColorSpace::ICCBased | array | Subtype, dict | Alternate, Metadata, N, Range | 
PDF::ColorSpace::Indexed | array | Base, Hival, Lookup, Subtype |  | 
PDF::ColorSpace::Lab | array | Subtype, dict | BlackPoint, Range, WhitePoint | 
PDF::ColorSpace::Pattern | array | Colorspace, Subtype |  | 
PDF::ColorSpace::Separation | array | AlternateSpace, Name, Subtype, TintTransform |  | 
PDF::Destination | array | fit, page | delegate-destination | 
PDF::Encoding | dict | BaseEncoding, Differences, Type |  | 
PDF::ExtGState | dict | AIS(alpha-source-flag), BG(black-generation-old), BG2(black-generation), BM(blend-mode), CA(stroke-alpha), D(dash-pattern), FL(flatness-tolerance), Font, HT(halftone), LC(line-cap), LJ(line-join), LW(line-width), ML(miter-limit), OP(overprint-paint), OPM(overprint-mode), RI(rendering-intent), SA(stroke-adjustment), SM(smoothness-tolerance), SMask(soft-mask), TK(text-knockout), TR(transfer-function-old), TR2(transfer-function), Type, UCR(under-color-removal-old), UCR2(under-color-removal), ca(fill-alpha), op(overprint-stroke) | transparency | /Type /ExtGState
PDF::Field::Button | dict | DV(default-value), Opt, V(value) |  | 
PDF::Field::Choice | dict | DV(default-value), I(indices), Opt, TI(top-index), V(value) |  | 
PDF::Field::Signature | dict | Lock, SV(seed-value) |  | 
PDF::Field::Text | dict | DV(default-value), MaxLen, V(value) |  | 
PDF::Font::CIDFont | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW, DW2, FontDescriptor, W, W2 |  | 
PDF::Font::CIDFontType0 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW, DW2, FontDescriptor, Subtype, Type, W, W2 | font-obj, make-font, set-font-obj | 
PDF::Font::CIDFontType2 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW, DW2, FontDescriptor, Subtype, Type, W, W2 | font-obj, make-font, set-font-obj | 
PDF::Font::MMType1 | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype, ToUnicode, Type, Widths | font-obj, make-font, set-font-obj | 
PDF::Font::TrueType | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype, ToUnicode, Type, Widths | font-obj, make-font, set-font-obj | TrueType fonts - /Type /Font /Subtype TrueType see [PDF 1.7 Section 5.5.2 TrueType Fonts]
PDF::FontDescriptor | dict | Ascent, AvgWidth, CapHeight, CharSet, Descent, Flags, FontBBox, FontFamily, FontFile, FontFile2, FontFile3, FontName, FontStretch, FontWeight, ItalicAngle, Leading, MaxWidth, MissingWidth, StemH, StemV, Type, XHeight |  | 
PDF::FontFile | stream | Length1, Length2, Length3, Metadata, Subtype |  | 
PDF::FontStream | dict | Length1, Length2, Length3, Metadata |  | 
PDF::Function::Exponential | stream | C0, C1, Domain, FunctionType, N, Range | calc, calculator | /FunctionType 2 - Exponential see [PDF 1.7 Section 3.9.2 Type 2 (Exponential Interpolation) Functions]
PDF::Function::PostScript | stream | Domain, FunctionType, Range | calc, calculator, parse | /FunctionType 4 - PostScript see [PDF 1.7 Section 3.9.4 Type 4 (PostScript Transform) Functions]
PDF::Function::Sampled | stream | BitsPerSample, Decode, Domain, Encode, FunctionType, Order, Range, Size | calc, calculator | /FunctionType 0 - Sampled see [PDF 1.7 Section 3.9.1 Type 0 (Sampled) Functions]
PDF::Function::Stitching | stream | Bounds, Domain, Encode, FunctionType, Functions, Range | calc, calculator | /FunctionType 3 - Stitching see [PDF 1.7 Section 3.9.3 Type 3 (Stitching) Functions]
PDF::Group::Transparency | dict | CS(color-space), I(isolated), K(knockout), S, Type |  | 
PDF::Image | stream | Alternatives, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Metadata, Name, OC, OPI, SMask, SMaskInData, StructParent, Width | to-png | 
PDF::MCR | dict | MCID, Pg(page), Stm, StmOwn, Type |  | 
PDF::Mask::Alpha | dict | BC(backdrop-color), G(transparency-group), S(subtype), TR(transfer-function), Type |  | 
PDF::Mask::Luminosity | dict | BC(backdrop-color), G(transparency-group), S(subtype), TR(transfer-function), Type |  | 
PDF::Metadata::XML | stream | Metadata, Subtype, Type |  | 
PDF::NameTree | dict | Kids, Limits, Names |  | 
PDF::NumberTree | dict | Kids, Limits, Nums |  | 
PDF::OBJR | dict | Obj, Pg(page), Type |  | /Type /OBJR - Object Reference dictionary
PDF::OCG | dict | Intent, Name, Type, Usage |  | 
PDF::OCMD | dict | OCGs, P, Type, VE |  | 
PDF::Outline | dict | A(action), C(color), Count, Dest, F(flags), First, Last, Next, Parent, Prev, SE(structure-element), Title |  | 
PDF::Outlines | dict | Count, First, Last, Type |  | 
PDF::OutputIntent::GTS_PDFX | dict | DestOutputProfile, Info, OutputCondition, OutputConditionIdentifier, RegistryName, S, Type |  | 
PDF::Page | dict | AA(additional-actions), Annots, ArtBox, B(beads), BleedBox, BoxColorInfo, Contents, CropBox, Dur(display-duration), Group, ID, LastModified, MediaBox, Metadata, PZ(preferred-zoom), Parent, PieceInfo, PressSteps, Resources, Rotate, SeparationInfo, StructParents, Tabs, TemplateInstantiated, Thumb(thumbnail-image), Trans(transition-effect), TrimBox, Type, UserUnit, VP(view-ports) | art-box, bbox, bleed-box, canvas, content-streams, contents, contents-parse, core-font, crop-box, fields, fields-hash, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, media-box, new-gfx, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, to-landscape, to-xobject, trim-box, use-font, use-resource, width, xobject-form | /Type /Page - describes a single PDF page
PDF::Pages | dict | Count, CropBox, Kids, MediaBox, Parent, Resources, Rotate, Type | add-page, add-pages, art-box, bbox, bleed-box, core-font, crop-box, find-resource, height, images, media-box, page-count, resource-entry, resource-key, to-landscape, trim-box, use-font, use-resource, width | /Type /Pages - a node in the page tree
PDF::Pattern::Shading | dict | ExtGState, Matrix, PatternType, Shading, Type |  | /ShadingType 2 - Axial
PDF::Pattern::Tiling | stream | BBox, Matrix, PaintType, PatternType, Resources, TilingType, Type, XStep, YStep | canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, new-gfx, open, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, use-font, use-resource, width, xobject-form | /ShadingType 1 - Tiling
PDF::Resources | dict | ColorSpace, ExtGState, Font, Pattern, ProcSet, Properties, Shading, XObject |  | 
PDF::Shading::Axial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 2 - Axial
PDF::Shading::Coons | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 6 - Coons
PDF::Shading::FreeForm | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 4 - FreeForm
PDF::Shading::Function | dict | AntiAlias, BBox, Background, ColorSpace, Domain, Function, Matrix, ShadingType |  | /ShadingType 1 - Functional
PDF::Shading::Lattice | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, ColorSpace, Decode, Function, ShadingType, VerticesPerRow |  | /ShadingType 5 - Lattice
PDF::Shading::Radial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 3 - Radial
PDF::Shading::Tensor | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 7 - Tensor
PDF::StructElem | dict | A(attributes), ActualText, Alt(alternative-description), C, E(expanded-form), ID, K(children), Lang, P(parent), Pg(page), R(revision), S(structure-type), T(title), Type |  | 
PDF::StructTreeRoot | dict | ClassMap, IDTree, K(children), ParentTree, ParentTreeNextKey, RoleMap, Type |  | 
PDF::XObject::Form | stream | BBox, FormType, Group, LastModified, Matrix, Metadata, Name, OC(optional-content-group), OPI, PieceInfo, Ref, Resources, StructParent, StructParents, Subtype, Type | canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, new-gfx, open, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, use-font, use-resource, width, xobject-form | XObject Forms - /Type /XObject /Subtype Form See [PDF Spec 1.7 4.9 Form XObjects]
PDF::XObject::Image | stream | Alternatives, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Metadata, Name, OC, OPI, SMask, SMaskInData, StructParent, Subtype, Type, Width | height, image-obj, inline-content, inline-to-xobject, open, to-png, width | XObjects /Type XObject /Subtype /Image See [PDF 1.7 Section 4.8 - Images ]
PDF::XObject::PS | stream | Level1, Subtype, Type |  | Postscript XObjects /Type XObject /Subtype PS See [PDF 1.7 Section 4.7.1 PostScript XObjects]

*(generated by `etc/make-quick-ref.pl`)*
