# PDF::Class

PDF::Class provides a set of roles and classes that map to the internal structure of PDF documents; the aim being to make it easier to read, write and validate PDF files.

It assists with the construction of valid PDF documents, providing type-checking and the sometimes finicky serialization rules regarding objects.

This is the base class for [PDF::API6](https://github.com/p6-pdf/PDF-API6).

## Description

The top level of a PDF document is of type `PDF::Class`. It contains the `PDF::Catalog` as its `Root` entry.

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

- This module contains definitions for many other standard PDF objects, such as Pages, Fonts and Images, as listed below.
- There is generally a one-to-one correspondence between raw dictionary entries and accessors, e.g. `$pdf<Root><AA>` versus `$pdf.Root.AA`.
- There are often accessor aliases, to aide clarity. E.g. `$pdf.Root.AA` can also be written as `$pdf.catalog.additional-actions`.
- The classes often contain additional accessor and helper methods. For example `$pdf.page(10)` - references page 10, without the need to navigate the catalog and page tree.

This module is a work in progress. It currently defines roles and classes for many of the more commonly occurring PDF objects as described in the [PDF 32000-1:2008 1.7](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/PDF32000_2008.pdf) specification.

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

## Gradual Types

In general, PDF::Class provides accessors for structured access and safe update of PDF objects.

However is is also possible to bypass these accessors; instead access hashes and arrays directly, giving raw access to the PDF data.

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

#### `pdf-append.p6 --save-as=output.pdf in1.pdf in2.pdf ...`

appends PDF files.

#### `pdf-burst.p6 --save-as=basename-%03d.pdf --password=pass in.pdf`

bursts a multi-page PDF into single page PDF files

#### `pdf-checker.p6 --trace --render --strict --max-depth=n --exclude=Entry1,Entry2 --repair input-pdf`

This is a low-level tool for PDF authors and users. It traverses a PDF, checking it's internal structure against
PDF:Class definitions as derived from the [PDF 32000-1:2008 1.7](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/PDF32000_2008.pdf) specification.

 - `--trace` print a dump of PDF Objects as the file is traversed
 - `--render` also render and check the contents of graphical objects, such as Pages and XObject forms
 - `--strict` perform additional checks:
 - `--max-depth` set maximum traversal depth.

#### Example 1: Dump a simple PDF

    % pdf-checker.p6 --trace t/helloworld.pdf
    xref:   << /ID ... /Info 1 0 R /Root 2 0 R >>  % PDF::Class
      /ID:  [ <d743a886fcdcf87b69c36548219ea941> <d743a886fcdcf87b69c36548219ea941> ]       % PDF::COS::Array[Str]
      /Info:        << /Author (t/helloworld.t) /CreationDate (D:20151225000000Z00'00') /Creator (PDF::Class) /Producer (Perl 6 PDF::Class 0.2.4) >>    % PDF::COS::Dict+{PDF::Info}
      /Root:        << /Type /Catalog /Pages 3 0 R >>       % PDF::Catalog
        /Pages:     << /Type /Pages /Count 1 /Kids ... /Resources ... >>    % PDF::Pages
          /Kids:    [ 4 0 R ]       % PDF::COS::Array[PDF::Content::PageNode]
            [0]:    << /Type /Page /Contents 5 0 R /MediaBox ... /Parent 3 0 R >>   % PDF::Page
              /Contents:    << /Length 1944 >>     % PDF::COS::Stream
              /MediaBox:    [ 0 0 595 842 ] % PDF::COS::Array[Numeric]
          /Resources:       << /ExtGState ... /Font ... /ProcSet ... /XObject ... >>        % PDF::COS::Dict+{PDF::Resources}
            /ExtGState:     << /GS1 6 0 R >>       % PDF::COS::Dict[Hash]
              /GS1: << /Type /ExtGState /ca 0.5 >> % PDF::COS::Dict+{PDF::ExtGState}
            /Font:  << /F1 7 0 R /F2 8 0 R /F3 9 0 R >>     % PDF::COS::Dict[PDF::Resources::Font]
              /F1:  << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>  % PDF::Font::Type1
              /F2:  << /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>       % PDF::Font::Type1
              /F3:  << /Type /Font /Subtype /Type1 /BaseFont /ZapfDingbats >>       % PDF::Font::Type1
            /ProcSet:       [ /PDF /Text ]  % PDF::COS::Array[PDF::COS::Name]
            /XObject:       << /Im1 10 0 R /Im2 11 0 R >>   % PDF::COS::Dict[PDF::Resources::XObject]
              /Im1: << /Type /XObject /Subtype /Image /BitsPerComponent 8 /ColorSpace /DeviceRGB /Filter /DCTDecode /Height 254 /Width 200 /Length 8247 >>      % PDF::XObject::Image
              /Im2: << /Type /XObject /Subtype /Image /BitsPerComponent 8 /ColorSpace ... /Height 42 /Width 37 /Length 1554 >>  % PDF::XObject::Image
                /ColorSpace:        [ /Indexed /DeviceRGB 255 12 0 R ]      % PDF::ColorSpace::Indexed
                  [3]:      << /Length 768 >>      % PDF::COS::Stream
    Checking of t/helloworld.pdf completed with 0 warnings and 0 errors

This example dumps a PDF and shows how PDF::Class has interpeted it.

- indirect object `1 0 R` is a dictionary that has had the `PDF::Info` role applied
- indirect object `2 0 R` has been loaded as a `PDF::Catalog` object.
- font `/F3` is a ZapfDingbats type1 font

The PDF contains has one page (PDF::Page) that references various other objects, such as fonts and
xobject images.

#### Example 2: Check a sample PDF

    % wget http://www.stillhq.com/pdfdb/000025/data.pdf
    % pdf-checker-p6 --strict --render data.pdf
    Warning: Error processing indirect object 27 0 R at byte offset 976986:
    Ignoring 1 bytes before 'endstream' marker
    Rendering warning(s) in 28 0 R (PDF::Page):
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    Rendering warning(s) in 30 0 R  (PDF::XObject::Form):
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    Unknown entries 1 0 R (PDF::Catalog) struct: /ViewPreferences
    Checking of /home/david/Documents/test-pdf/000025.pdf completed with 5 warnings and 0 errors

In this example:

- Object `28 0 R` had an extra byte in its stream data.
- Some Page and XObject graphics operations were not in the
   expected order, (as outlined in PDF 32000 Figure 9 – Graphics Objects).
- The Catalog dictionary had an unexpected `/ViewPreferences`
   entry (It should be `/ViewerPreferences`, see PDF::Catalog).

#### Notes

- A message such as `No handler class PDF::Filespec`, usually indicates the the object has not yet been implemented in PDF::Class.

#### `pdf-info.p6 in.pdf`

prints various PDF properties

#### `pdf-revert.p6 --password=pass --save-as=out.pdf in.pdf`

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
PDF::Action::JavaScript | dict | JS, Next, S, Type |  | /Action Subtype - GoTo
PDF::Action::Named | dict | N(action-name), Next, S, Type |  | /Action Subtype - GoTo
PDF::Action::URI | dict | Base, IsMap, Next, S, Type, URI |  | /Action Subtype - URI
PDF::Annot::Caret | dict | AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect, StructParent, Subtype, Sy(symbol), T(text-label), Type |  | 
PDF::Annot::Circle | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), IC(interior-color), M(mod-time), NM(annotation-name), OC(optional-content), P(page), RD(rectangle-differences), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::FileAttachment | dict | AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FS(file-spec), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), P(page), Popup, RC(rich-text), RT(reply-type), Rect, StructParent, Subtype, T(text-label), Type |  | 
PDF::Annot::Link | dict | A(action), AP(appearance), AS(appearance-state), BS, Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), Dest, ExData(external-data), F(flags), H(highlight-mode), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), PA(uri-action), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect, StructParent, Subtype, T(text-label), Type | | 
PDF::Annot::Markup | dict | AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RT(reply-type), Rect, StructParent, Subtype, T(text-label), Type |  | 
PDF::Annot::Popup | dict | AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), M(mod-time), NM(annotation-name), OC(optional-content), Open, P(page), Parent, Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Square | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), IC(interior-color), M(mod-time), NM(annotation-name), OC(optional-content), P(page), RD(rectangle-differences), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Text | dict | AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), Open, P(page), Popup, RC(rich-text), RT(reply-type), Rect, State, StateModel, StructParent, Subtype, T(text-label), Type | | /Type Annot - Annonation subtypes See [PDF 1.7 Section 8.4 Annotations]
PDF::Annot::ThreeD | dict | 3DA(activation), 3DB(view-box), 3DD(artwork), 3DI(interactive), 3DV(default-view), AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Rect, StructParent, Subtype, Type |  | 
PDF::Annot::Widget | dict | A(action), AA(additional-actions), AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), H(highlight-mode), M(mod-time), MK, NM(annotation-name), OC(optional-content), P(page), Rect, StructParent, Subtype, Type |  | 
PDF::Appearance | dict | D(down), N(normal), R(rollover) |  | 
PDF::Border | dict | D(dash-pattern), S(style), Type, W(width) |  | 
PDF::CIDSystemInfo | dict | Ordering, Registry, Supplement |  | 
PDF::CMap | stream | CIDSystemInfo, CMapName, Type, UseCMap, WMode |  | /Type /CMap
PDF::Class::ThreeD | dict | 3DA(activation), 3DB(view-box), 3DD(artwork), 3DI(interactive), 3DV(default-view) |  | 
PDF::ColorSpace::CalGray | array | Subtype, dict | BlackPoint, Gamma, WhitePoint | 
PDF::ColorSpace::CalRGB | array | Subtype, dict | BlackPoint, Gamma, Matrix, WhitePoint | 
PDF::ColorSpace::DeviceN | array | AlternateSpace, Attributes, Names, Subtype, TintTransform |  | 
PDF::ColorSpace::ICCBased | array | Subtype, dict | Alternate, Metadata, N, Range | 
PDF::ColorSpace::Indexed | array | Base, Hival, Lookup, Subtype |  | 
PDF::ColorSpace::Lab | array | Subtype, dict | BlackPoint, Range, WhitePoint | 
PDF::ColorSpace::Pattern | array | Colorspace, Subtype |  | 
PDF::ColorSpace::Separation | array | AlternateSpace, Name, Subtype, TintTransform |  | 
PDF::Destination | array | fit, page | delegate-destination, is-page-ref | 
PDF::Encoding | dict | BaseEncoding, Differences, Type |  | 
PDF::ExtGState | dict | AIS(alpha-source-flag), BG(black-generation-old), BG2(black-generation), BM(blend-mode), CA(stroke-alpha), D(dash-pattern), FL(flatness-tolerance), Font, HT(halftone), LC(line-cap), LJ(line-join), LW(line-width), ML(miter-limit), OP(overprint-paint), OPM(overprint-mode), RI(rendering-intent), SA(stroke-adjustment), SM(smoothness-tolerance), SMask(soft-mask), TK(text-knockout), TR(transfer-function-old), TR2(transfer-function), Type, UCR(under-color-removal-old), UCR2(under-color-removal), ca(fill-alpha), op(overprint-stroke) | transparency | /Type /ExtGState
PDF::Field::Button | dict | DV(default-value), Opt, V(value) |  | 
PDF::Field::Choice | dict | DV(default-value), I(indices), Opt, TI(top-index), V(value) |  | 
PDF::Field::Signature | dict | Lock, SV(seed-value), V(value) |  | 
PDF::Field::Text | dict | DV(default-value), MaxLen, V(value) |  | 
PDF::Font::CIDFont | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, W(widths), W2(heights) |  | 
PDF::Font::CIDFontType0 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype, Type, W(widths), W2(heights) | font-obj, make-font, set-font-obj | 
PDF::Font::CIDFontType2 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype, Type, W(widths), W2(heights) | font-obj, make-font, set-font-obj | 
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
PDF::Mask::Alpha | dict | BC(backdrop-color), G(transparency-group), S, TR(transfer-function), Type |  | 
PDF::Mask::Luminosity | dict | BC(backdrop-color), G(transparency-group), S, TR(transfer-function), Type |  | 
PDF::Metadata::XML | stream | Metadata, Subtype, Type |  | 
PDF::NameTree | dict | Kids, Limits, Names |  | 
PDF::NumberTree | dict | Kids, Limits, Nums |  | 
PDF::OBJR | dict | Obj, Pg(page), Type |  | /Type /OBJR - Object Reference dictionary
PDF::OCG | dict | Intent, Name, Type, Usage |  | 
PDF::OCMD | dict | OCGs, P(visibility-policy), Type, VE(visibility-expression) |  |
PDF::Outline | dict | A(action), C(color), Count, Dest, F(flags), First, Last, Next, Parent, Prev, SE(structure-element), Title |  | 
PDF::Outlines | dict | Count, First, Last, Type |  | 
PDF::OutputIntent::GTS_PDFX | dict | DestOutputProfile, Info, OutputCondition, OutputConditionIdentifier, RegistryName, S, Type |  | 
PDF::Page | dict | AA(additional-actions), Annots, ArtBox, B(beads), BleedBox, BoxColorInfo, Contents, CropBox, Dur(display-duration), Group, ID, LastModified, MediaBox, Metadata, PZ(preferred-zoom), Parent, PieceInfo, PressSteps, Resources, Rotate, SeparationInfo, StructParents, Tabs, TemplateInstantiated, Thumb(thumbnail-image), Trans(transition-effect), TrimBox, Type, UserUnit, VP(view-ports) | art-box, bbox, bleed-box, canvas, contents, contents-parse, core-font, crop-box, fields, fields-hash, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, media-box, new-gfx, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, to-landscape, to-xobject, trim-box, use-font, use-resource, width, xobject-form | /Type /Page - describes a single PDF page
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
