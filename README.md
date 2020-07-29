[[Raku PDF Project]](https://pdf-raku.github.io)
 / [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku)

# PDF::Class

This Raku module is the base class for [PDF::API6](https://pdf-raku.github.io/PDF-API6).

PDF::Class provides a set of roles and classes that map to the internal structure of PDF documents; the aim being to make it easier to read, write valid PDF files.

It assists with the construction of PDF documents, providing type-checking and the sometimes finicky serialization rules regarding objects.

## Description

The entry point of a PDF document is the trailer dictionary. This is mapped to `PDF::Class`. It contains a `Root` entry which is mapped to a `PDF::Catalog` objects, and may contain other entries, including and `Info` entry mapped to a `PDF::Info` object.

```
    use PDF::Class;
    use PDF::Catalog;
    use PDF::Page;
    use PDF::Info;

    my PDF::Class $pdf .= open: "t/helloworld.pdf";

    # vivify Info entry; set title
    given $pdf.Info //= {} -> PDF::Info $_ {
        .Title = 'Hello World!';
        .ModDate = DateTime.now; # PDF::Class sets this anyway...
    }

    # modify Viewer Preferences
    my PDF::Catalog $catalog = $pdf.Root;
    given $catalog.ViewerPreferences //= {} {
        .HideToolbar = True;
    }

    # add a page ...
    my PDF::Page $new-page = $pdf.add-page;
    $new-page.gfx.say: "New last page!";

    # save the updated pdf
    $pdf.save-as: "tmp/pdf-updated.pdf", :!info;
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
    my PDF::Catalog $catalog = $pdf.catalog; # same as $pdf.Root;
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

## Gradual Typing

In theory, we should always be able to use PDF::Class accessors for structured access and updating of PDF objects.

In reality, a fair percentage of PDF files contain at least some conformance issues (as reported by `pdf-checker.raku`) and PDF::Class itself
is under development.

For these reasons it possible to bypass PDF::Class accessors; instead accessing hashes and arrays directly, giving raw access to the PDF data.

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

#### `pdf-append.raku --save-as=output.pdf in1.pdf in2.pdf ...`

appends PDF files.

#### `pdf-burst.raku --save-as=basename-%03d.pdf --password=pass in.pdf`

bursts a multi-page PDF into single page PDF files

#### `pdf-checker.raku --trace --render --strict --exclude=Entry1,Entry2 --repair input-pdf`

This is a low-level tool for PDF authors and users. It traverses a PDF, checking it's internal structure against
PDF:Class definitions as derived from the [PDF 32000-1:2008 1.7](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/PDF32000_2008.pdf) specification.

 - `--trace` print a dump of PDF Objects as the file is traversed
 - `--render` also render and check the contents of graphical objects, such as Pages and XObject forms
 - `--strict` perform additional checks:
  - `--repair` repair PDF before Checking

#### Example 1: Dump a simple PDF

    % pdf-checker.raku --trace t/helloworld.pdf
    xref:   << /ID ... /Info 1 0 R /Root 2 0 R >>   % PDF::Class
      /ID:  [ "×C¨\x[86]üÜø\{iÃeH!\x[9E]©A" "×C¨\x[86]üÜø\{iÃeH!\x[9E]©A" ] % PDF::COS::Array[Str]
      /Info:        << /Author "t/helloworld.t" /CreationDate (D:20151225000000Z00'00') /Creator "PDF::Class" /Producer "Raku PDF::Class 0.2.5" >>        % PDF::COS::Dict+{PDF::Info}
      /Root:        << /Type /Catalog /Pages 3 0 R >>       % PDF::Catalog
        /Pages:     << /Type /Pages /Count 1 /Kids ... /Resources ... >>    % PDF::Pages
          /Kids:    [ 4 0 R ]       % PDF::COS::Array[PDF::Content::PageNode]
            [0]:    << /Type /Page /Contents 5 0 R /MediaBox ... /Parent 3 0 R >>   % PDF::Page
              /Contents:    << /Length 1944 >>      % PDF::COS::Stream
              /MediaBox:    [ 0 0 595 842 ] % PDF::COS::Array[Numeric]
          /Resources:       << /ExtGState ... /Font ... /ProcSet ... /XObject ... >>        % PDF::COS::Dict+{PDF::Resources}
            /ExtGState:     << /GS1 6 0 R >>        % PDF::COS::Dict[Hash]
              /GS1: << /Type /ExtGState /ca 0.5 >>  % PDF::COS::Dict+{PDF::ExtGState}
            /Font:  << /F1 7 0 R /F2 8 0 R /F3 9 0 R >>     % PDF::COS::Dict[PDF::Resources::Font]
              /F1:  << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>  % PDF::Font::Type1
              /F2:  << /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>       % PDF::Font::Type1
              /F3:  << /Type /Font /Subtype /Type1 /BaseFont /ZapfDingbats >>       % PDF::Font::Type1
            /ProcSet:       [ /PDF /Text ]  % PDF::COS::Array[PDF::COS::Name]
            /XObject:       << /Im1 10 0 R /Im2 11 0 R >>   % PDF::COS::Dict[PDF::Resources::XObject]
              /Im1: << /Type /XObject /Subtype /Image /BitsPerComponent 8 /ColorSpace /DeviceRGB /Filter /DCTDecode /Height 254 /Width 200 /Length 8247 >>  % PDF::XObject::Image
              /Im2: << /Type /XObject /Subtype /Image /BitsPerComponent 8 /ColorSpace ... /Height 42 /Width 37 /Length 1554 >>      % PDF::XObject::Image
                /ColorSpace:        [ /Indexed /DeviceRGB 255 12 0 R ]      % PDF::ColorSpace::Indexed
                  [3]:      << /Length 768 >>       % PDF::COS::Stream
    Checking of t/helloworld.pdf completed with 0 warnings and 0 errors

This example dumps a PDF and shows how PDF::Class has interpreted it.

- indirect object `1 0 R` is a dictionary that has had the `PDF::Info` role applied
- indirect object `2 0 R` has been loaded as a `PDF::Catalog` object.
- font `/F3` is a ZapfDingbats type1 font

The PDF contains has one page (PDF::Page) that references various other objects, such as fonts and
xobject images.

#### Example 2: Check a sample PDF

    % wget http://www.stillhq.com/pdfdb/000025/data.pdf
    % pdf-checker.raku --strict --render data.pdf
    Warning: Error processing indirect object 27 0 R at byte offset 976986:
    Ignoring 1 bytes before 'endstream' marker
    Rendering warning(s) in 28 0 R (PDF::Page):
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    Rendering warning(s) in 30 0 R  (PDF::XObject::Form):
    -- unexpected operation 'w' (SetLineWidth) used in Path context, following 'm' (MoveTo)
    Unknown entries 1 0 R (PDF::Catalog) struct: /ViewPreferences(?ViewerPreferences)
    Checking of /home/david/Documents/test-pdf/000025.pdf completed with 5 warnings and 0 errors

In this example:

- Object `28 0 R` had an extra byte in its stream data.
- Some Page and XObject graphics operations were not in the
   expected order, (as outlined in PDF 32000 Figure 9 – Graphics Objects).
- The Catalog dictionary had an unexpected `/ViewPreferences`
   entry (It should be `/ViewerPreferences`, see PDF::Catalog).

##### Notes

- A message such as `No handler class PDF::Filespec`, usually indicates the the object has not yet been implemented in PDF::Class.

#### `pdf-content-dump.raku --raku in.pdf`

Displays the content streams for PDF pages, commented,
and in a human-readable format:

    % pdf-content-dump.raku t/example.pdf 
    % **** Page 1 ****
    BT % BeginText
      1 0 0 1 100 150 Tm % SetTextMatrix
      /F1 16 Tf % SetFont
      17.6 TL % SetTextLeading
      [ (Hello, world!) ] TJ % ShowSpaceText
      T* % TextNextLine
    ET % EndText

The `--raku` option dumps using a Raku-like notation:

    pdf-content-dump.raku --perl t/example.pdf 
    # **** Page 1 ****
    .BeginText();
      .SetTextMatrix(1, 0, 0, 1, 100, 150);
      .SetFont("F1", 16);
      .SetTextLeading(17.6);
      .ShowSpaceText($["Hello, world!"]);
      .TextNextLine();
    .EndText();

#### `pdf-info.raku in.pdf`

Prints various PDF properties. For example:

    % pdf-info.raku ~/Documents/test-pdfs/stillhq.com/000056.pdf 
    File:         /home/david/Documents/test-pdfs/stillhq.com/000056.pdf
    File Size:    63175 bytes
    Pages:        2
    Outlines:     no
    Author:       Prince Restaurant
    CreationDate: Wed Oct 03 23:41:01 2001
    Creator:      FrameMaker+SGML 6.0
    Keywords:     Pizza, Pasta, Antipasto, Lasagna, Food
    ModDate:      Thu Oct 04 00:03:04 2001
    Producer:     Acrobat PDFWriter 4.05  for Power Macintosh
    Subject:      Take Out & Catering Menu
    Title:        Prince Pizzeria & Bar
    Tagged:       no
    Page Size:    variable
    PDF version:  1.3
    Revisions:    1
    Encryption:   no

#### `pdf-fields.raku --password=pass --page=n  --save-as=out.pdf [options] in.pdf`

##### Modes
   - --list [--labels]                 % list fields and current values
   - --fill [--labels] key value ...   % fill fields from keys and values
   - --slice=i value value ...         % set consecutive fields from values
   - --reset [-/reformat] [-triggers]  % reset fields. Defaults: remove formats, keep triggers

##### General Options:
   - --page=n             select nth page
   - --save-as=out.pdf    save to a file
   - --password           provide user/owner password for an encrypted PDF

List, reformat or set PDF form fields.

#### `pdf-revert.raku --password=pass --save-as=out.pdf in.pdf`

undoes the last revision of an incrementally saved PDF file.

#### `pdf-toc.raku --password=pass --/title --/labels in.pdf`

prints a table of contents, showing titles and page-numbers, using PDF outlines.

    % wget http://www.stillhq.com/pdfdb/000432/data.pdf
    % pdf-toc.raku data.pdf
    Linux Kernel Modules Installation HOWTO
      Table of Contents . . . i
      1. Purpose of this Document . . . 1
      2. Pre-requisites . . . 2
      3. Compiler Speed-up . . . 3
      4. Recompiling the Kernel for Modules . . . 4
        5.1. Configuring Debian or RedHat for Modules . . . 5
        5.2. Configuring Slackware for Modules . . . 5
        5.3. Configuring Other Distributions for Modules . . . 6

Note that outlines are an optional PDF feature. `pdf-info.raku` can be
used to check if a PDF has them:

    % pdf-info.raku my-doc.pdf | grep Outlines:

## Development Status

The PDF::Class module is under construction and not yet functionally complete.

Note: The roles and classes in this module are primarly based on roles generated by the PDF::ISO_32000 module.
The PDF::class module currently implements around 100 roles and classes of the 350+ objects extracted by PDF::ISO_32000.

## See also

- [PDF::Lite](https://pdf-raku.github.io/PDF-Lite-raku) - A Lite-weight alternative
- [PDF::API6](https://github.com/p6-raku/PDF-API6) - general purpose PDF manipulation, based on this
module (PDF::Class)
- [PDF::ISO_32000](https://pdf-raku.github.io/PDF-ISO_32000-raku) - A set of interface roles that have
been mined from the PDF 32000 specification, e.g. ISO_32000::Table_28-Entries_in_the_catalog_dictionary.

## Classes Quick Reference

Class | Types | Accessors | Methods | Description | ISO-32000 References
------|-------|-----------|---------|-------------|----------
PDF::Class | dict | Encrypt, ID, Info, Prev, Root(catalog), Size | Blob, Pages, ast, crypt, encrypt, open, permitted, save-as, update, version | PDF entry-point. either a trailer dict or an XRef stream | Table_15-Entries_in_the_file_trailer_dictionary
PDF::Catalog | dict | AA(additional-actions), AcroForm, Collection, Dests, Extensions, Lang, Legal, MarkInfo, Metadata, Names, NeedsRendering, OCProperties, OpenAction, Outlines, OutputIntents, PageLabels, PageLayout, PageMode, Pages, Perms, PieceInfo, Requirements, Resources, SpiderInfo, StructTreeRoot, Threads, Type, URI, Version, ViewerPreferences | core-font, find-resource, images, resource-entry, resource-key, use-font, use-resource | /Type /Catalog - usually the document root in a PDF See [PDF 32000 Section 7.7.2 Document Catalog] | Table_28-Entries_in_the_catalog_dictionary
PDF::AcroForm | dict | CO(calculation-order), DA(default-appearance), DR(default-resources), Fields, NeedAppearances, Q(quadding), SigFlags, XFA | fields, fields-hash |  | Table_218-Entries_in_the_interactive_form_dictionary
PDF::Action::GoTo | dict | D(destination), Next, S, Type |  | /Action Subtype - GoTo | Table_199-Additional_entries_specific_to_a_go-to_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::GoToR | dict | D(destination), F(file), NewWindow, Next, S, Type |  | /Action Subtype - GoToR | Table_200-Additional_entries_specific_to_a_remote_go-to_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::JavaScript | dict | JS, Next, S, Type |  | /Action Subtype - GoTo | Table_217-Additional_entries_specific_to_a_JavaScript_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::Launch | dict | F(file), Mac, NewWindow, Next, S, Type, Unix, Win |  | /Action Subtype - Launch | Table_203-Additional_entries_specific_to_a_launch_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::Named | dict | N(action-name), Next, S, Type |  | /Action Subtype - GoTo | Table_212-Additional_entries_specific_to_named_actions Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::Thread | dict | B(bead), D(thread), F(file-spec), Next, S, Type |  | /Action Subtype - Thread | Table_205-Additional_entries_specific_to_a_thread_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Action::URI | dict | IsMap, Next, S, Type, URI |  | /Action Subtype - URI | Table_206-Additional_entries_specific_to_a_URI_action Table_193-Entries_common_to_all_action_dictionaries
PDF::Annot::Caret | dict | AP(appearance), AS(appearance-state), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FT(field-type), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect, StructParent, Subj, Subtype, Sy(symbol), T(text-label), Type |  |  | Table_180-Additional_entries_specific_to_a_caret_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Circle | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FT(field-type), IC(interior-color), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect, StructParent, Subj, Subtype, T(text-label), Type |  |  | Table_177-Additional_entries_specific_to_a_square_or_circle_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::FileAttachment | dict | AP(appearance), AS(appearance-state), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FS(file-spec), FT(field-type), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), P(page), Popup, RC(rich-text), RT(reply-type), Rect, StructParent, Subj, Subtype, T(text-label), Type |  |  | Table_184-Additional_entries_specific_to_a_file_attachment_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Link | dict | A(action), AP(appearance), AS(appearance-state), BS, Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), Dest, ExData(external-data), F(flags), FT(field-type), H(highlight-mode), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), PA(uri-action), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect, StructParent, Subj, Subtype, T(text-label), Type |  |  | Table_173-Additional_entries_specific_to_a_link_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Popup | dict | AP(appearance), AS(appearance-state), Border, C(color), Contents, DR(default-resources), F(flags), FT(field-type), M(mod-time), NM(annotation-name), OC(optional-content), Open, P(page), Parent, Rect, StructParent, Subtype, Type |  |  | Table_183-Additional_entries_specific_to_a_pop-up_annotation Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Square | dict | AP(appearance), AS(appearance-state), BE(border-effect), BS(border-style), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FT(field-type), IC(interior-color), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect, StructParent, Subj, Subtype, T(text-label), Type |  |  | Table_177-Additional_entries_specific_to_a_square_or_circle_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Text | dict | AP(appearance), AS(appearance-state), Border, C(color), CA(constant-opacity), Contents, CreationDate, DR(default-resources), ExData(external-data), F(flags), FT(field-type), IRT(reply-to-ref), IT(intent), M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), Open, P(page), Popup, RC(rich-text), RT(reply-type), Rect, State, StateModel, StructParent, Subj, Subtype, T(text-label), Type |  | /Type Annot - Annonation subtypes See [PDF 32000 Section 12.5 Annotations] | Table_172-Additional_entries_specific_to_a_text_annotation Table_170-Additional_entries_specific_to_markup_annotations Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::ThreeD | dict | 3DA(activation), 3DB(view-box), 3DD(artwork), 3DI(interactive), 3DV(default-view), AP(appearance), AS(appearance-state), Border, C(color), Contents, DR(default-resources), F(flags), FT(field-type), M(mod-time), NM(annotation-name), OC(optional-content), P(page), Rect, StructParent, Subtype, Type |  |  | Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Widget | dict | A(action), AA(additional-actions), AP(appearance), AS(appearance-state), BS(border-style), Border, C(color), Contents, DR(default-resources), F(flags), FT(field-type), H(highlight-mode), M(mod-time), MK, NM(annotation-name), OC(optional-content), P(page), Parent, Rect, StructParent, Subtype, Type |  |  | Table_188-Additional_entries_specific_to_a_widget_annotation Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Appearance | dict | D(down), N(normal), R(rollover) |  |  | Table_168-Entries_in_an_appearance_dictionary
PDF::Border | dict | D(dash-pattern), S(style), Type, W(width) |  |  | Table_166-Entries_in_a_border_style_dictionary
PDF::CIDSystemInfo | dict | Ordering, Registry, Supplement |  |  | Table_116-Entries_in_a_CIDSystemInfo_dictionary
PDF::CMap | stream | CIDSystemInfo, CMapName, Type, UseCMap, WMode |  | /Type /CMap | Table_120-Additional_entries_in_a_CMap_stream_dictionary
PDF::ColorSpace::CalGray | array | Subtype, dict | props |  | 
PDF::ColorSpace::CalRGB | array | Subtype, dict | props |  | 
PDF::ColorSpace::DeviceN | array | AlternateSpace, Attributes, Names, Subtype, TintTransform |  |  | 
PDF::ColorSpace::ICCBased | array | Subtype, dict | props |  | 
PDF::ColorSpace::Indexed | array | Base, Hival, Lookup, Subtype |  |  | 
PDF::ColorSpace::Lab | array | Subtype, dict | props |  | 
PDF::ColorSpace::Pattern | array | Colorspace, Subtype |  |  | 
PDF::ColorSpace::Separation | array | AlternateSpace, Name, Subtype, TintTransform |  |  | 
PDF::Destination | array | fit, page | delegate-destination, is-page-ref |  | Table_151-Destination_syntax
PDF::Encoding | dict | BaseEncoding, Differences, Type |  |  | Table_114-Entries_in_an_encoding_dictionary
PDF::ExData::Markup3D | dict | 3DA(activation), 3DV(default-view), MD5, Subtype, Type |  |  | Table_313-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations
PDF::ExtGState | dict | AIS(alpha-source-flag), BG(black-generation-old), BG2(black-generation), BM(blend-mode), CA(stroke-alpha), D(dash-pattern), FL(flatness-tolerance), Font, HT(halftone), LC(line-cap), LJ(line-join), LW(line-width), ML(miter-limit), OP(overprint-paint), OPM(overprint-mode), RI(rendering-intent), SA(stroke-adjustment), SM(smoothness-tolerance), SMask(soft-mask), TK(text-knockout), TR(transfer-function-old), TR2(transfer-function), Type, UCR(under-color-removal-old), UCR2(under-color-removal), ca(fill-alpha), op(overprint-stroke) | transparency |  | Table_58-Entries_in_a_Graphics_State_Parameter_Dictionary
PDF::Field::Button | dict | DV(default-value), Opt, V(value) |  |  | Table_220-Entries_common_to_all_field_dictionaries Table_227-Additional_entry_specific_to_check_box_and_radio_button_fields
PDF::Field::Choice | dict | DV(default-value), I(indices), Opt, TI(top-index), V(value) |  |  | Table_220-Entries_common_to_all_field_dictionaries Table_231-Additional_entries_specific_to_a_choice_field
PDF::Field::Signature | dict | Lock, SV(seed-value), V(value) | DV |  | Table_220-Entries_common_to_all_field_dictionaries Table_252-Entries_in_a_signature_dictionary
PDF::Field::Text | dict | DV(default-value), MaxLen, V(value) |  |  | Table_220-Entries_common_to_all_field_dictionaries Table_229-Additional_entry_specific_to_a_text_field
PDF::Filespec | dict | CI, DOS, Desc, EF(embedded-files), F(file-name), FS(file-system), ID, Mac, RF(related-files), Type(type), UF, Unix, V(volatile) |  |  | Table_44-Entries_in_a_file_specification_dictionary
PDF::Font::CIDFont | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype, Type, W(widths), W2(heights) | font-obj, make-font, set-font-obj |  | Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::CIDFontType0 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype, Type, W(widths), W2(heights) | font-obj, make-font, set-font-obj |  | Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::CIDFontType2 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype, Type, W(widths), W2(heights) | font-obj, make-font, set-font-obj |  | Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::MMType1 | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype, ToUnicode, Type, Widths | font-obj, make-font, set-font-obj |  | Table_111-Entries_in_a_Type_1_font_dictionary
PDF::Font::TrueType | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype, ToUnicode, Type, Widths | font-obj, make-font, set-font-obj | Table_111-Entries_in_a_Type_1_font_dictionary
PDF::FontDescriptor | dict | Type, FontName, FontFamily, FontStretch, FontWeight, Flags, FontBBox, ItalicAngle, Ascent, Descent, Leading, CapHeight, XHeight, StemV, StemH, AvgWidth, MaxWidth, MissingWidth, FontFile, FontFile2, FontFile3, CharSet |  |  | Table_122-Entries_common_to_all_font_descriptors
PDF::FontDescriptor::CID | dict | Type, FontName, FontFamily, FontStretch, FontWeight, Flags, FontBBox, ItalicAngle, Ascent, Descent, Leading, CapHeight, XHeight, StemV, StemH, AvgWidth, MaxWidth, MissingWidth, FontFile, FontFile2, FontFile3, CharSet, CIDSet, FD, Lang, Style |  |  | Table_122-Entries_common_to_all_font_descriptors Table_117-Entries_in_a_CIDFont_dictionary
PDF::FontFile | stream | Length1, Length2, Length3, Metadata, Subtype |  |  | Table_127-Additional_entries_in_an_embedded_font_stream_dictionary
PDF::FontStream | dict | Length1, Length2, Length3, Metadata |  |  |
PDF::Function::Exponential | stream | C0, C1, Domain, FunctionType, N, Range | calc, calculator | /FunctionType 2 - Exponential | Table_38-Entries_common_to_all_function_dictionaries Table_40-Additional_entries_specific_to_a_type_2_function_dictionary
PDF::Function::PostScript | stream | Domain, FunctionType, Range | calc, calculator, parse | /FunctionType 4 - PostScript see [PDF 32000 Section 7.10.5 Type 4 (PostScript Transform) Functions] | Table_38-Entries_common_to_all_function_dictionaries Section 7.10.5 Type 4 (PostScript Transform) Functions
PDF::Function::Sampled | stream | BitsPerSample, Decode, Domain, Encode, FunctionType, Order, Range, Size | calc, calculator | /FunctionType 0 - Sampled see [PDF 32000 Section 7.10.2 Type 0 (Sampled) Functions] | Table_38-Entries_common_to_all_function_dictionaries Table_39-Additional_entries_specific_to_a_type_0_function_dictionary
PDF::Function::Stitching | stream | Bounds, Domain, Encode, FunctionType, Functions, Range | calc, calculator | /FunctionType 3 - Stitching see [PDF 32000 Section 7.4.10 Type 3 (Stitching) Functions] | Table_38-Entries_common_to_all_function_dictionaries Table_41-Additional_entries_specific_to_a_type_3_function_dictionary
PDF::Group::Transparency | dict | CS(color-space), I(isolated), K(knockout), S, Type |  |  | Table_96-Entries_Common_to_all_Group_Attributes_Dictionaries Table_147-Additional_entries_specific_to_a_transparency_group_attributes_dictionary
PDF::ICCProfile | dict | Alternate, Metadata, N(num-colors), Range |  |  | Table_66-Additional_Entries_Specific_to_an_ICC_Profile_Stream_Dictionary
PDF::Image | stream | Alternates, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Metadata, Name, OC(optional-content), OPI, SMask, SMaskInData, StructParent, Subtype, Type, Width | to-png |  | Table_89-Additional_Entries_Specific_to_an_Image_Dictionary
PDF::Info | dict | Title, Author, CreationDate, Creator, Keywords, ModDate, Producer, Subject, Trapped  |  |  | Table_317-Entries_in_the_document_information_dictionary
PDF::MCR | dict | MCID, Pg(page), Stm, StmOwn, Type |  |  | Table_324-Entries_in_a_marked-content_reference_dictionary
PDF::Mask::Alpha | dict | BC(backdrop-color), G(transparency-group), S(subtype), TR(transfer-function), Type |  |  | Table_144-Entries_in_a_soft-mask_dictionary
PDF::Mask::Luminosity | dict | BC(backdrop-color), G(transparency-group), S(subtype), TR(transfer-function), Type |  |  | Table_144-Entries_in_a_soft-mask_dictionary
PDF::Metadata::XML | stream | Metadata, Subtype, Type |  |  | Table_315-Additional_entries_in_a_metadata_stream_dictionary
PDF::NameTree | dict | Kids, Limits, Names |  |  | Table_36-Entries_in_a_name_tree_node_dictionary
PDF::NumberTree | dict | Kids, Limits, Nums |  |  | Table_37-Entries_in_a_number_tree_node_dictionary
PDF::OBJR | dict | Obj, Pg(page), Type |  | /Type /OBJR - Object Reference dictionary | Table_325-Entries_in_an_object_reference_dictionary
PDF::OCG | dict | Intent, Name, Type, Usage |  |  | Table_98-Entries_in_an_Optional_Content_Group_Dictionary
PDF::OCMD | dict | OCGs, P(visibility-policy), Type, VE(visibility-expression) |  |  | Table_99-Entries_in_an_Optional_Content_Membership_Dictionary
PDF::Outline | dict | A(action), C(color), Count, Dest, F(flags), First, Last, Next, Parent, Prev, SE(structure-element), Title |  |  | Table_152-Entries_in_the_outline_dictionary
PDF::Outlines | dict | Count, First, Last, Type |  |  | Table_153-Entries_in_an_outline_item_dictionary
PDF::OutputIntent::GTS_PDFX | dict | DestOutputProfile, Info, OutputCondition, OutputConditionIdentifier, RegistryName, S, Type |  |  | Table_365-Entries_in_an_output_intent_dictionary
PDF::Page | dict | AA(additional-actions), Annots, ArtBox, B(beads), BleedBox, BoxColorInfo, Contents, CropBox, Dur(display-duration), Group, ID, LastModified, MediaBox, Metadata, PZ(preferred-zoom), Parent, PieceInfo, PresSteps, Resources, Rotate, SeparationInfo, StructParents(struct-parent), Tabs, TemplateInstantiated, Thumb(thumbnail-image), Trans(transition-effect), TrimBox, Type, UserUnit, VP(view-ports) | art-box, bbox, bleed-box, canvas, contents, contents-parse, core-font, crop-box, fields, fields-hash, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, media-box, new-gfx, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, to-landscape, to-xobject, trim-box, use-font, use-resource, width, xobject-form | /Type /Page - describes a single PDF page | Table_30-Entries_in_a_page_object
PDF::Pages | dict | Count, CropBox, Kids, MediaBox, Parent, Resources, Rotate, Type | add-page, add-pages, art-box, bbox, bleed-box, core-font, crop-box, find-resource, height, images, media-box, page-count, page-index, resource-entry, resource-key, to-landscape, trim-box, use-font, use-resource, width | /Type /Pages - a node in the page tree | Table_29-Required_entries_in_a_page_tree_node
PDF::Pattern::Shading | dict | ExtGState, Matrix, PatternType, Shading, Type |  | /ShadingType 2 - Axial | Table_76-Entries_in_a_Type_2_Pattern_Dictionary
PDF::Pattern::Tiling | stream | BBox, Matrix, PaintType, PatternType, Resources, TilingType, Type, XStep, YStep | canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, new-gfx, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, use-font, use-resource, width, xobject-form | /PatternType 1 - Tiling | Table_75-Additional_Entries_Specific_to_a_Type_1_Pattern_Dictionary
PDF::Resources | dict | ColorSpace, ExtGState, Font, Pattern, ProcSet, Properties, Shading, XObject |  |  | Table_33-Entries_in_a_resource_dictionary
PDF::Signature | dict | ByteRange, Cert, Changes, ContactInfo, Contents, Location, M(date-signed), Name, Prop_AuthTime, Prop_AuthType, Prop_Build, R, Reason, Reference, SubFilter, Type, V |  |  | Table_252-Entries_in_a_signature_dictionary
PDF::Shading::Axial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 2 - Axial | Table_78-Entries_Common_to_All_Shading_Dictionaries
PDF::Shading::Coons | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 6 - Coons | Table_78-Entries_Common_to_All_Shading_Dictionaries Table_84-Additional_Entries_Specific_to_a_Type_6_Shading_Dictionary
PDF::Shading::FreeForm | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 4 - FreeForm | Table_78-Entries_Common_to_All_Shading_Dictionaries Table_82-Additional_Entries_Specific_to_a_Type_4_Shading_Dictionary
PDF::Shading::Function | dict | AntiAlias, BBox, Background, ColorSpace, Domain, Function, Matrix, ShadingType |  | /ShadingType 1 - Functional | Table_78-Entries_Common_to_All_Shading_Dictionaries Table_79-Additional_Entries_Specific_to_a_Type_1_Shading_Dictionary
PDF::Shading::Lattice | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, ColorSpace, Decode, Function, ShadingType, VerticesPerRow |  | /ShadingType 5 - Lattice | Table_78-Entries_Common_to_All_Shading_Dictionaries Table_83-Additional_Entries_Specific_to_a_Type_5_Shading_Dictionary
PDF::Shading::Radial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 3 - Radial | Table_78-Entries_Common_to_All_Shading_Dictionaries Table_81-Additional_Entries_Specific_to_a_Type_3_Shading_Dictionary
PDF::Shading::Tensor | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 7 - Tensor | Table_78-Entries_Common_to_All_Shading_Dictionaries [PDF 32000 Section 8.7.4.5.8 - Type 7 Shadings (Tensor-Product Patch Meshes)]
PDF::Signature | dict | ByteRange, Cert, Changes, ContactInfo, Contents, Location, M(date-signed), Name, Prop_AuthTime, Prop_AuthType, Prop_Build, Reason, Reference, SubFilter, Type, V |  |  | Table_252-Entries_in_a_signature_dictionary
PDF::StructElem | dict | A(attributes), ActualText, Alt(alternative-description), C, E(expanded-form), ID, K(kids), Lang, P(parent), Pg(page), R(revision), S(tag), T(title), Type |  | | Table_323-Entries_in_a_structure_element_dictionary
PDF::StructTreeRoot | dict | ClassMap, IDTree, K(kids), ParentTree, ParentTreeNextKey, RoleMap, Type |  |  | Table_322-Entries_in_the_structure_tree_root
PDF::ViewerPreferences | dict | CenterWindow, Direction, DisplayDocTitle, Duplex, FitWindow, HideMenubar, HideToolbar, HideWindowUI, NonFullScreenPageMode, NumCopies, PickTrayByPDFSize, PrintArea, PrintPageRange, PrintScaling, ViewArea, ViewClip |  |  | Table_322-Entries_in_the_structure_tree_root
PDF::XObject::Form | stream | BBox, FormType, Group, LastModified, Matrix, Metadata, Name, OC(optional-content-group), OPI, PieceInfo, Ref, Resources, StructParent, StructParents, Subtype, Type | canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, images, new-gfx, pre-gfx, pre-graphics, render, resource-entry, resource-key, save-as-image, text, tiling-pattern, use-font, use-resource, width, xobject-form | XObject Forms - /Type /XObject /Subtype Form See [PDF Spec 1.7 4.9 Form XObjects] | Table_95-Additional_Entries_Specific_to_a_Type_1_Form_Dictionary
PDF::XObject::Image | stream | Alternates, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Metadata, Name, OC(optional-content), OPI, SMask, SMaskInData, StructParent, Subtype, Type, Width | height, image-obj, inline-content, inline-to-xobject, to-png, width | XObjects /Type XObject /Subtype /Image See [PDF 32000 Section 8.9 - Images ] | Table_89-Additional_Entries_Specific_to_an_Image_Dictionary
PDF::XObject::PS | stream | Level1, Subtype, Type |  | Postscript XObjects /Type XObject /Subtype PS See [PDF 32000 Section 8.8.2 PostScript XObjects] | Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary

*(generated by `etc/make-quick-ref.pl`)*
