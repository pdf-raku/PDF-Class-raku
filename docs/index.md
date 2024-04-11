[[Raku PDF Project]](https://pdf-raku.github.io)
 / [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku)

 <a href="https://travis-ci.org/pdf-raku/PDF-Class-raku"><img src="https://travis-ci.org/pdf-raku/PDF-Class-raku.svg?branch=master"></a>
 <a href="https://ci.appveyor.com/project/dwarring/PDF-Class-raku/branch/master"><img src="https://ci.appveyor.com/api/projects/status/github/pdf-raku/PDF-Class-raku?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true"></a>

# PDF::Class

This Raku module is the base class for [PDF::API6](https://pdf-raku.github.io/PDF-API6).

PDF::Class provides a set of roles and classes that map to the internal structure of PDF documents; the aim being to make it easier to read, write valid PDF files.

It assists with the construction of PDF documents, providing type-checking and the sometimes finicky serialization rules regarding objects.

## Description

The entry point of a PDF document is the trailer dictionary. This is mapped to `PDF::Class`. It contains a `Root` entry which is mapped to a `PDF::Catalog` objects, and may contain other entries, including an `Info` entry mapped to a `PDF::Info` object.

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
    $pdf.save-as: "tmp/pdf-updated.pdf";
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
    use PDF::MarkInfo;
    my PDF::Class $pdf .= new;
    my PDF::Catalog $catalog = $pdf.catalog; # same as $pdf.Root;
    with $catalog.MarkInfo //= {} -> PDF::MarkInfo $_ {
        .Marked = True;
        .UserProperties = False;
        .Suspects = False;
    }
```


### Set Page Layout & Viewer Preferences
```
    use PDF::Class;
    use PDF::Catalog;
    use PDF::Viewer::Preferences;

    my PDF::Class $pdf .= new;

    my PDF::Catalog $doc = $pdf.catalog;
    $doc.PageLayout = 'TwoColumnLeft';
    $doc.PageMode   = 'UseThumbs';

    given $doc.ViewerPreferences //= {} -> PDF::Viewer::Preferences $_ {
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
the following example forces the setting of PageMode to an illegal value.

```
    use PDF::Class;
    use PDF::Catalog;
    use PDF::COS::Name;
    my PDF::Class $pdf .= new;

    my PDF::Catalog $doc = $pdf.catalog;
    try {
        $doc.PageMode = 'UseToes'; # illegal
        CATCH { default { say "err, that didn't work: $_" } }
    }

    # same again, bypassing type checking
    $doc<PageMode> = PDF::COS::Name.COERCE: 'UseToes';
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
-------- | -------- | -------- | -------- | -------- | --------
[PDF::Class](https://pdf-raku.github.io/PDF-Class-raku/PDF/Class) | dict | Encrypt, ID, Info, Prev, Root(catalog), Size, XRefStm | Blob, Pages, add-page, add-pages, art-box, ast, bleed, bleed-box, core-font, creator, crop-box, crypt, delete-page, encrypt, fields, fields-hash, id, insert-page, iterate-pages, media-box, open, page, page-count, pages, permitted, save-as, trim-box, update, use-font, version | PDF entry-point. either a trailer dict or an XRef stream | ISO_32000_2::Table_19-Additional_entries_in_a_hybrid-reference_files_trailer_dictionary ISO_32000_2::Table_15-Entries_in_the_file_trailer_dictionary ISO_32000::Table_15-Entries_in_the_file_trailer_dictionary
PDF::AcroForm | dict | CO(calculation-order), DA(default-appearance), DR(default-resources), Fields, NeedAppearances, Q(quadding), SigFlags, XFA | fields, take-fields | AcroForm role - see PDF::Catalog - /AcroForm entry | ISO_32000::Table_218-Entries_in_the_interactive_form_dictionary ISO_32000_2::Table_224-Entries_in_the_interactive_form_dictionary
PDF::Action::GoTo | dict | D(destination), Next, S(subtype), SD, Type(type) |  | /Action Subtype - GoTo | ISO_32000_2::Table_202-Additional_entries_specific_to_a_go-to_action ISO_32000::Table_199-Additional_entries_specific_to_a_go-to_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::GoToR | dict | D(destination), F(file), NewWindow, Next, S(subtype), SD, Type(type) |  | /Action Subtype - GoToR | ISO_32000_2::Table_203-Additional_entries_specific_to_a_remote_go-to_action ISO_32000::Table_200-Additional_entries_specific_to_a_remote_go-to_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::JavaScript | dict | JS(java-script), Next, S(subtype), Type(type) |  | /Action Subtype - JavaScript | ISO_32000_2::Table_221-Additional_entries_specific_to_an_ECMAScript_action ISO_32000::Table_217-Additional_entries_specific_to_a_JavaScript_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::Launch | dict | F(file), Mac, NewWindow, Next, S(subtype), Type(type), Unix, Win |  | /Action Subtype - Launch | ISO_32000_2::Table_207-Additional_entries_specific_to_a_launch_action ISO_32000::Table_203-Additional_entries_specific_to_a_launch_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::Named | dict | N(action-name), Next, S(subtype), Type(type) |  | /Action Subtype - GoTo | ISO_32000_2::Table_216-Additional_entries_specific_to_named_actions ISO_32000::Table_212-Additional_entries_specific_to_named_actions ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::Sound | dict | Mix, Next, Repeat, S(subtype), Sound, Synchronous, Type(type), Volume |  | /Action Subtype - Sound | ISO_32000_2::Table_212-Additional_entries_specific_to_a_sound_action ISO_32000::Table_208-Additional_entries_specific_to_a_sound_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
[PDF::Action::SubmitForm](https://pdf-raku.github.io/PDF-Class-raku/PDF/Action/SubmitForm) | dict | CharSet, Fields, Flags, Next, S(subtype), Type(type) |  | /Action Subtype - URI | ISO_32000_2::Table_239-Additional_entries_specific_to_a_submit-form_action ISO_32000::Table_236-Additional_entries_specific_to_a_submit-form_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::Thread | dict | B(bead), D(thread), F(file), Next, S(subtype), Type(type) |  | /Action Subtype - Thread | ISO_32000_2::Table_209-Additional_entries_specific_to_a_thread_action ISO_32000::Table_205-Additional_entries_specific_to_a_thread_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
PDF::Action::URI | dict | IsMap, Next, S(subtype), Type(type), URI |  | /Action Subtype - URI | ISO_32000_2::Table_210-Additional_entries_specific_to_a_URI_action ISO_32000::Table_206-Additional_entries_specific_to_a_URI_action ISO_32000::Table_193-Entries_common_to_all_action_dictionaries ISO_32000_2::Table_196-Entries_common_to_all_action_dictionaries
[PDF::Annot::AdditionalActions](https://pdf-raku.github.io/PDF-Class-raku/PDF/Annot/AdditionalActions) | dict | Bl(blur), D(mouse-down), E(enter), Fo(focus), PC(page-close), PI(page-invisable), PO(page-open), PV(page-visable), U(mouse-up), X(exit) |  |  | ISO_32000::Table_194-Entries_in_an_annotations_additional-actions_dictionary ISO_32000_2::Table_197-Entries_in_an_annotations_additional-actions_dictionary
PDF::Annot::Caret | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), Sy(symbol), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_183-Additional_entries_specific_to_a_caret_annotation ISO_32000::Table_180-Additional_entries_specific_to_a_caret_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Circle | dict | AF, AP(appearance), AS(appearance-state), BE(border-effect), BM, BS(border-style), Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IC(interior-color), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_180-Additional_entries_specific_to_a_square_or_circle_annotation ISO_32000::Table_177-Additional_entries_specific_to_a_square_or_circle_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::FileAttachment | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FS(file-spec), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), P(page), Popup, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_187-Additional_entries_specific_to_a_file_attachment_annotation ISO_32000::Table_184-Additional_entries_specific_to_a_file_attachment_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Highlight | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Link | dict | A(action), AF, AP(appearance), AS(appearance-state), BM, BS(border-style), Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), Dest(destination), ExData(external-data), F(annot-flags), FT(field-type), H(highlight-mode), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), PA(uri-action), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_176-Additional_entries_specific_to_a_link_annotation ISO_32000::Table_173-Additional_entries_specific_to_a_link_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Popup | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA, Contents(content), DR(default-resources), F(annot-flags), FT(field-type), Lang, M(mod-time), NM(annotation-name), OC(optional-content), Open, P(page), Parent, Rect(rect), StructParent(struct-parent), Subtype(subtype), Type(type), ca | annots |  | ISO_32000_2::Table_186-Additional_entries_specific_to_a_popup_annotation ISO_32000::Table_183-Additional_entries_specific_to_a_pop-up_annotation ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Square | dict | AF, AP(appearance), AS(appearance-state), BE(border-effect), BM, BS(border-style), Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IC(interior-color), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RD(rectangle-differences), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_180-Additional_entries_specific_to_a_square_or_circle_annotation ISO_32000::Table_177-Additional_entries_specific_to_a_square_or_circle_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Squiggly | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::StrikeOut | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Text | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), Name(icon-name), OC(optional-content), Open, P(page), Popup, RC(rich-text), RT(reply-type), Rect(rect), State, StateModel, StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots | /Type Annot - Annotation subtypes See [PDF 32000 Section 12.5 Annotations] | ISO_32000_2::Table_175-Additional_entries_specific_to_a_text_annotation ISO_32000::Table_172-Additional_entries_specific_to_a_text_annotation ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::ThreeD | dict | 3DA(activation), 3DB(view-box), 3DD(artwork), 3DI(interactive), 3DU(units), 3DV(default-view), AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA, Contents(content), DR(default-resources), F(annot-flags), FT(field-type), GEO, Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Rect(rect), StructParent(struct-parent), Subtype(subtype), Type(type), ca | annots |  | ISO_32000_2::Table_309-Additional_entries_specific_to_a_ThreeD_annotation ISO_32000::Table_298-Additional_entries_specific_to_a_ThreeD_annotation ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Underline | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::Widget | dict | A(action), AA(additional-actions), AF, AP(appearance), AS(appearance-state), BM, BS(border-style), Border, C(color), CA, Contents(content), DR(default-resources), F(annot-flags), FT(field-type), H(highlight-mode), Lang, M(mod-time), MK, NM(annotation-name), OC(optional-content), P(page), Parent, Rect(rect), StructParent(struct-parent), Subtype(subtype), Type(type), ca | annots |  | ISO_32000_2::Table_191-Additional_entries_specific_to_a_widget_annotation ISO_32000::Table_188-Additional_entries_specific_to_a_widget_annotation ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::_Markup | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots |  | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Annot::_TextMarkup | dict | AF, AP(appearance), AS(appearance-state), BM, Border, C(color), CA(constant-opacity), Contents(content), CreationDate, DR(default-resources), ExData(external-data), F(annot-flags), FT(field-type), IRT(reply-to-ref), IT(intent), Lang, M(mod-time), NM(annotation-name), OC(optional-content), P(page), Popup, QuadPoints, RC(rich-text), RT(reply-type), Rect(rect), StructParent(struct-parent), Subj, Subtype(subtype), T(text-label), Type(type), ca | annots | /Type Annot - Annotation subtypes See [PDF 32000 Section 12.5 Annotations] | ISO_32000_2::Table_172-Additional_entries_in_an_annotation_dictionary_specific_to_markup_annotations ISO_32000::Table_170-Additional_entries_specific_to_markup_annotations ISO_32000_2::Table_166-Entries_common_to_all_annotation_dictionaries ISO_32000::Table_164-Entries_common_to_all_annotation_dictionaries
PDF::Appearance | dict | D(down), N(normal), R(rollover) |  | Appearance role - see PDF::Annot - /AP entry | ISO_32000::Table_168-Entries_in_an_appearance_dictionary ISO_32000_2::Table_170-Entries_in_an_appearance_dictionary
PDF::Attributes::Layout | dict | BBox, BackgroundColor, BaselineShift, BlockAlign, BorderColor, BorderStyle, BorderThickness, Color, ColumnCount, ColumnGap, ColumnWidths, EndIndent, GlyphOrientationVertical, Height, InlineAlign, LineHeight, NS(namespace=), O(owner), Padding, Placement, RubyAlign, RubyPosition, SpaceAfter, SpaceBefore, StartIndent, TBorderStyle, TPadding, TextAlign, TextDecorationColor, TextDecorationThickness, TextDecorationType, TextIndent, TextPosition, Width, WritingMode |  |  | ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries ISO_32000::Table_343-Standard_layout_attributes_common_to_all_standard_structure_types ISO_32000_2::Table_378-Standard_layout_attributes_common_to_all_standard_structure_types ISO_32000::Table_344-Additional_standard_layout_attributes_specific_to_block-level_structure_elements ISO_32000_2::Table_379-Additional_standard_layout_attributes_specific_to_block-level_structure_elements ISO_32000::Table_345-Standard_layout_attributes_specific_to_inline-level_structure_elements ISO_32000_2::Table_380-Standard_layout_attributes_specific_to_inline-level_structure_elements ISO_32000::Table_346-Standard_column_attributes ISO_32000_2::Table_381-Standard_layout_attributes_specific_to_standard_column_attributes
PDF::Attributes::List | dict | ContinuedFrom, ContinuedList, ListNumbering, NS(namespace=), O(owner) |  | Standard list attribute | ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries ISO_32000::Table_347-Standard_list_attribute ISO_32000_2::Table_382-Standard_list_attributes
PDF::Attributes::PrintField | dict | Checked, Desc, NS(namespace=), O(owner), Role, checked |  | PrintField attributes | ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries ISO_32000::Table_348-PrintField_attributes ISO_32000_2::Table_383-PrintField_attributes
PDF::Attributes::Table | dict | ColSpan, Headers, NS(namespace=), O(owner), RowSpan, Scope, Short, Summary |  | Table Table 349 – Standard table attributes | ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries ISO_32000::Table_349-Standard_table_attributes ISO_32000_2::Table_384-Standard_table_attributes
PDF::Attributes::UserProperties | dict | NS(namespace=), O(owner), P(properties) | set-attribute |  | ISO_32000::Table_327-Entry_common_to_all_attribute_object_dictionaries ISO_32000_2::Table_360-Entries_common_to_all_attribute_object_dictionaries ISO_32000::Table_328-Additional_entries_in_an_attribute_object_dictionary_for_user_properties ISO_32000_2::Table_361-Additional_entries_in_an_attribute_object_dictionary_for_user_properties
PDF::Border | dict | D(dash-pattern), S(style), Type, W(width) |  | /Type /Border | ISO_32000::Table_166-Entries_in_a_border_style_dictionary ISO_32000_2::Table_168-Entries_in_a_border_style_dictionary
PDF::CIDSystemInfo | dict | Ordering, Registry, Supplement |  |  | ISO_32000::Table_116-Entries_in_a_CIDSystemInfo_dictionary ISO_32000_2::Table_114-Entries_in_a_CIDSystemInfo_dictionary
PDF::CMap | stream | CIDSystemInfo, CMapName, Type(type), UseCMap, WMode |  | /Type /CMap | ISO_32000_2::Table_118-Additional_entries_in_a_CMap_stream_dictionary ISO_32000::Table_120-Additional_entries_in_a_CMap_stream_dictionary
[PDF::Catalog::AdditionalActions](https://pdf-raku.github.io/PDF-Class-raku/PDF/Catalog/AdditionalActions) | dict | DP(did-print), DS(did-save), WC(will-close), WP(will-print), WS(will-save) |  |  | ISO_32000::Table_197-Entries_in_the_document_catalogs_additional-actions_dictionary ISO_32000_2::Table_200-Entries_in_the_document_catalogs_additional-actions_dictionary
PDF::ColorSpace::CalGray | array | Subtype, dict | BlackPoint, Gamma, WhitePoint, props |  | 
PDF::ColorSpace::CalRGB | array | Subtype, dict | BlackPoint, Gamma, Matrix, WhitePoint, props |  | 
PDF::ColorSpace::DeviceN | array | AlternateSpace, Attributes, Names, Subtype, TintTransform |  |  | 
PDF::ColorSpace::ICCBased | array | Subtype, dict | Alternate, Metadata, N, Range, props |  | 
PDF::ColorSpace::Indexed | array | Base, Hival, Lookup, Subtype |  |  | 
PDF::ColorSpace::Lab | array | Subtype, dict | BlackPoint, Range, WhitePoint, props |  | 
PDF::ColorSpace::Pattern | array | Colorspace, Subtype |  |  | 
PDF::ColorSpace::Separation | array | AlternateSpace, Name, Subtype, TintTransform |  |  | 
PDF::Destination | array | fit, page | delegate-destination, is-page-ref |  | 
PDF::EmbeddedFile | dict | Params, Type |  |  | ISO_32000::Table_45-Additional_entries_in_an_embedded_file_stream_dictionary ISO_32000_2::Table_44-Additional_entries_in_an_embedded_file_stream_dictionary
PDF::Encoding | dict | BaseEncoding, Differences, Type |  | /Type /Encoding | ISO_32000::Table_114-Entries_in_an_encoding_dictionary ISO_32000_2::Table_112-Entries_in_an_encoding_dictionary
PDF::ExData::Markup3D | dict | 3DA(activation), 3DV(default-view), MD5, Subtype(subtype), Type(type) |  |  | ISO_32000_2::Table_324-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations ISO_32000::Table_313-Entries_in_an_external_data_dictionary_used_to_markup_ThreeD_annotations
PDF::ExtGState | dict | AIS(alpha-source-flag), BG(black-generation-old), BG2(black-generation), BM(blend-mode), CA(stroke-alpha), D(dash-pattern), FL(flatness-tolerance), Font, HT(halftone), HTO, LC(line-cap), LJ(line-join), LW(line-width), ML(miter-limit), OP(overprint-paint), OPM(overprint-mode), RI(rendering-intent), SA(stroke-adjustment), SM(smoothness-tolerance), SMask(soft-mask), TK(text-knockout), TR(transfer-function-old), TR2(transfer-function), Type, UCR(under-color-removal-old), UCR2(under-color-removal), UseBlackPtComp, ca(fill-alpha), op(overprint-stroke) | transparency | /Type /ExtGState | ISO_32000::Table_58-Entries_in_a_Graphics_State_Parameter_Dictionary ISO_32000_2::Table_57-Entries_in_a_graphics_state_parameter_dictionary
[PDF::Field::AdditionalActions](https://pdf-raku.github.io/PDF-Class-raku/PDF/Field/AdditionalActions) | dict | C(calculate), F(format), K(change), V(validate) |  |  | ISO_32000::Table_196-Entries_in_a_form_fields_additional-actions_dictionary ISO_32000_2::Table_199-Entries_in_a_form_fields_additional-actions_dictionary
PDF::Field::Button | dict | AA(additional-actions), DA(default-appearance), DS(default-style), DV(default-value), FT(subtype), Ff(field-flags), Kids, Opt, Parent, Q(quadding), RV(rich-text), T(key), TM(tag), TU(label), V |  |  | ISO_32000::Table_227-Additional_entry_specific_to_check_box_and_radio_button_fields ISO_32000_2::Table_230-Additional_entry_specific_to_check_box_and_radio_button_fields
PDF::Field::Choice | dict | AA(additional-actions), DA(default-appearance), DS(default-style), DV(default-value), FT(subtype), Ff(field-flags), I(indices), Kids, Opt, Parent, Q(quadding), RV(rich-text), T(key), TI(top-index), TM(tag), TU(label), V |  |  | ISO_32000::Table_231-Additional_entries_specific_to_a_choice_field ISO_32000_2::Table_234-Additional_entries_specific_to_a_choice_field
PDF::Field::Signature | dict | AA(additional-actions), DA(default-appearance), DS(default-style), FT(subtype), Ff(field-flags), Kids, Lock, Parent, Q(quadding), RV(rich-text), SV(seed-value), T(key), TM(tag), TU(label), V(value) | DV |  | ISO_32000::Table_232-Additional_entries_specific_to_a_signature_field ISO_32000_2::Table_235-Additional_entries_specific_to_a_signature_field
PDF::Field::Text | dict | AA(additional-actions), DA(default-appearance), DS(default-style), DV(default-value), FT(subtype), Ff(field-flags), Kids, MaxLen, Parent, Q(quadding), RV(rich-text), T(key), TM(tag), TU(label), V |  |  | ISO_32000::Table_229-Additional_entry_specific_to_a_text_field ISO_32000_2::Table_232-Additional_entry_specific_to_a_text_field
PDF::Filespec | dict | AFRelationship, CI, DOS, Desc, EF(embedded-files), EP, F(file-name), FS(file-system), ID, Mac, RF(related-files), Thumb, Type(type), UF, Unix, V(volatile) |  |  | ISO_32000::Table_44-Entries_in_a_file_specification_dictionary ISO_32000_2::Table_43-Entries_in_a_file_specification_dictionary
PDF::Font::CIDFont | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype(subtype), Type(type), W(widths), W2(heights) | encode-cids, filter, font-name, font-obj, height, kern, make-font, protect, set-font-obj, stringwidth, underline-position, underline-thickness, units-per-EM |  | ISO_32000_2::Table_115-Entries_in_a_CIDFont_dictionary ISO_32000::Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::CIDFontType0 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype(subtype), Type(type), W(widths), W2(heights) | encode-cids, filter, font-name, font-obj, height, kern, make-font, protect, set-font-obj, stringwidth, underline-position, underline-thickness, units-per-EM |  | ISO_32000_2::Table_115-Entries_in_a_CIDFont_dictionary ISO_32000::Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::CIDFontType2 | dict | BaseFont, CIDSystemInfo, CIDToGIDMap, DW(default-width), DW2(default-width-and-height), FontDescriptor, Subtype(subtype), Type(type), W(widths), W2(heights) | encode-cids, filter, font-name, font-obj, height, kern, make-font, protect, set-font-obj, stringwidth, underline-position, underline-thickness, units-per-EM |  | ISO_32000_2::Table_115-Entries_in_a_CIDFont_dictionary ISO_32000::Table_117-Entries_in_a_CIDFont_dictionary
PDF::Font::MMType1 | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype(subtype), ToUnicode, Type(type), Widths | encode-cids, filter, font-name, font-obj, height, kern, make-font, protect, set-font-obj, stringwidth, underline-position, underline-thickness, units-per-EM |  | ISO_32000_2::Table_109-Entries_in_a_Type_1_font_dictionary ISO_32000::Table_111-Entries_in_a_Type_1_font_dictionary
PDF::Font::TrueType | dict | BaseFont, Encoding, FirstChar, FontDescriptor, LastChar, Name, Subtype(subtype), ToUnicode, Type(type), Widths | encode-cids, filter, font-name, font-obj, height, kern, make-font, protect, set-font-obj, stringwidth, underline-position, underline-thickness, units-per-EM | TrueType fonts - /Type /Font /Subtype TrueType see [PDF 32000 Section 9.6.3 TrueType Fonts] | ISO_32000_2::Table_109-Entries_in_a_Type_1_font_dictionary ISO_32000::Table_111-Entries_in_a_Type_1_font_dictionary
PDF::FontDescriptor::CID | dict | Ascent, AvgWidth, CIDSet, CapHeight, CharSet, Descent, FD, Flags, FontBBox, FontFamily, FontFile, FontFile2, FontFile3, FontName, FontStretch, FontWeight, ItalicAngle, Lang, Leading, MaxWidth, MissingWidth, StemH, StemV, Style, Type, XHeight |  |  | ISO_32000::Table_122-Entries_common_to_all_font_descriptors ISO_32000_2::Table_120-Entries_common_to_all_font_descriptors ISO_32000::Table_124-Additional_font_descriptor_entries_for_CIDFonts ISO_32000_2::Table_122-Additional_font_descriptor_entries_for_CIDFonts
PDF::FontFile | stream | Length1, Length2, Length3, Metadata, Subtype |  |  | ISO_32000_2::Table_125-Additional_entries_in_an_embedded_font_stream_dictionary ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary
PDF::FontStream | dict | Length1, Length2, Length3, Metadata |  | Target of PDF::FontDescriptor FontFile or FontFile2 Attribute; | 
PDF::Function::Exponential | stream | C0, C1, Domain, FunctionType, N, Range | calc, calculator | /FunctionType 2 - Exponential | ISO_32000_2::Table_40-Additional_entries_specific_to_a_Type_2_function_dictionary ISO_32000::Table_40-Additional_entries_specific_to_a_type_2_function_dictionary ISO_32000_2::Table_38-Entries_common_to_all_function_dictionaries ISO_32000::Table_38-Entries_common_to_all_function_dictionaries
PDF::Function::PostScript | stream | Domain, FunctionType, Range | calc, calculator, parse | /FunctionType 4 - PostScript see [PDF 32000 Section 7.10.5 Type 4 (PostScript Transform) Functions] | ISO_32000_2::Table_38-Entries_common_to_all_function_dictionaries ISO_32000::Table_38-Entries_common_to_all_function_dictionaries
PDF::Function::Sampled | stream | BitsPerSample, Decode, Domain, Encode, FunctionType, Order, Range, Size | calc, calculator | /FunctionType 0 - Sampled see [PDF 32000 Section 7.10.2 Type 0 (Sampled) Functions] | ISO_32000_2::Table_39-Additional_entries_specific_to_a_Type_0_function_dictionary ISO_32000::Table_39-Additional_entries_specific_to_a_type_0_function_dictionary ISO_32000_2::Table_38-Entries_common_to_all_function_dictionaries ISO_32000::Table_38-Entries_common_to_all_function_dictionaries
PDF::Function::Stitching | stream | Bounds, Domain, Encode, FunctionType, Functions, Range | calc, calculator | /FunctionType 3 - Stitching see [PDF 32000 Section 7.4.10 Type 3 (Stitching) Functions] | ISO_32000_2::Table_41-Additional_entries_specific_to_a_Type_3_function_dictionary ISO_32000::Table_41-Additional_entries_specific_to_a_type_3_function_dictionary ISO_32000_2::Table_38-Entries_common_to_all_function_dictionaries ISO_32000::Table_38-Entries_common_to_all_function_dictionaries
PDF::Group::Transparency | dict | CS(color-space), I(isolated), K(knockout), S, Type(type) |  |  | ISO_32000_2::Table_145-Additional_entries_specific_to_a_transparency_group_attributes_dictionary ISO_32000::Table_147-Additional_entries_specific_to_a_transparency_group_attributes_dictionary ISO_32000_2::Table_94-Entries_common_to_all_group_attributes_dictionaries ISO_32000::Table_96-Entries_Common_to_all_Group_Attributes_Dictionaries
PDF::ICCProfile | dict | Alternate, Metadata, N(num-colors), Range |  |  | ISO_32000::Table_66-Additional_Entries_Specific_to_an_ICC_Profile_Stream_Dictionary ISO_32000_2::Table_65-Additional_entries_specific_to_an_ICC_profile_stream_dictionary
[PDF::Image](https://pdf-raku.github.io/PDF-Class-raku/PDF/Image) | stream | AF, Alternates, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Measure, Metadata, Name, OC(optional-content), OPI, PtData, SMask, SMaskInData, StructParent(struct-parent), Subtype, Type, Width | to-png |  | ISO_32000::Table_89-Additional_Entries_Specific_to_an_Image_Dictionary ISO_32000_2::Table_87-Additional_entries_specific_to_an_image_dictionary
PDF::Info | dict | Author, CreationDate, Creator, Keywords, ModDate, Producer, Subject, Title, Trapped |  |  | ISO_32000::Table_317-Entries_in_the_document_information_dictionary ISO_32000_2::Table_349-Entries_in_the_document_information_dictionary
PDF::MCR | dict | MCID, Pg(page), Stm, StmOwn, Type(type) |  |  | ISO_32000_2::Table_357-Entries_in_a_marked-content_reference_dictionary ISO_32000::Table_324-Entries_in_a_marked-content_reference_dictionary
PDF::MarkInfo | dict | Marked, Suspects, UserProperties |  |  | ISO_32000::Table_321-Entries_in_the_mark_information_dictionary ISO_32000_2::Table_353-Entries_in_the_mark_information_dictionary
PDF::Mask::Alpha | dict | BC(backdrop-color), G(transparency-xobject), S(subtype), TR(transfer-function), Type |  |  | ISO_32000::Table_144-Entries_in_a_soft-mask_dictionary ISO_32000_2::Table_142-Entries_in_a_soft-mask_dictionary
PDF::Mask::Luminosity | dict | BC(backdrop-color), G(transparency-xobject), S(subtype), TR(transfer-function), Type |  |  | ISO_32000::Table_144-Entries_in_a_soft-mask_dictionary ISO_32000_2::Table_142-Entries_in_a_soft-mask_dictionary
PDF::Metadata::XML | stream | Metadata, Subtype(subtype), Type(type) |  |  | ISO_32000_2::Table_347-Additional_entries_in_a_metadata_stream_dictionary ISO_32000::Table_315-Additional_entries_in_a_metadata_stream_dictionary
PDF::NameTree | dict | Kids, Limits, Names | coercer, name-tree |  | ISO_32000::Table_36-Entries_in_a_name_tree_node_dictionary ISO_32000_2::Table_36-Entries_in_a_name_tree_node_dictionary
PDF::Names | dict | AP, AlternatePresentations, Dests, EmbeddedFiles, IDS, JavaScript, Pages, Renditions, Templates, URLS |  |  | ISO_32000::Table_31-Entries_in_the_name_dictionary ISO_32000_2::Table_32-Entries_in_the_name_dictionary
PDF::Namespace | dict | NS, RoleMapNS, Schema, Type |  |  | ISO_32000_2::Table_356-Entries_in_a_namespace_dictionary
PDF::NumberTree | dict | Kids, Limits, Nums | coercer, number-tree |  | ISO_32000::Table_37-Entries_in_a_number_tree_node_dictionary ISO_32000_2::Table_37-Entries_in_a_number_tree_node_dictionary
PDF::OBJR | dict | Obj(object), Pg(page), Type(type) |  | /Type /OBJR - Object Reference dictionary | ISO_32000_2::Table_358-Entries_in_an_object_reference_dictionary ISO_32000::Table_325-Entries_in_an_object_reference_dictionary
PDF::OCG | dict | Intent, Name, Type(type), Usage |  | /Type /OCG - Optional Content Group | ISO_32000_2::Table_96-Entries_in_an_optional_content_group_dictionary ISO_32000::Table_98-Entries_in_an_Optional_Content_Group_Dictionary
PDF::OCMD | dict | OCGs, P(visibility-policy), Type(type), VE(visibility-expression) |  |  | ISO_32000_2::Table_97-Entries_in_an_optional_content_membership_dictionary ISO_32000::Table_99-Entries_in_an_Optional_Content_Membership_Dictionary
PDF::Outline | dict | A(action), C(color), Count, Dest(destination), F(flags), First, Last, Next, Parent, Prev, SE(structure-element), Title |  | Outline - an entry in the Outlines Dictionary See /First and /Last Accessors in PDF::Outlines | ISO_32000::Table_153-Entries_in_an_outline_item_dictionary ISO_32000_2::Table_151-Entries_in_an_outline_item_dictionary
PDF::Outlines | dict | Count, First, Last, Type |  | /Type /Outlines - the Outlines dictionary | ISO_32000::Table_152-Entries_in_the_outline_dictionary ISO_32000_2::Table_150-Entries_in_the_outline_dictionary
PDF::OutputIntent | dict | DestOutputProfile, DestOutputProfileRef, Info, MixingHints, OutputCondition, OutputConditionIdentifier, RegistryName, S(subtype), SpectralData, Type(type) |  | /Type /OutputIntent | ISO_32000::Table_365-Entries_in_an_output_intent_dictionary ISO_32000_2::Table_401-Entries_in_an_output_intent_dictionary
[PDF::Page::AdditionalActions](https://pdf-raku.github.io/PDF-Class-raku/PDF/Page/AdditionalActions) | dict | C(page-close), O(page-open) |  |  | ISO_32000::Table_195-Entries_in_a_page_objects_additional-actions_dictionary ISO_32000_2::Table_198-Entries_in_a_page_objects_additional-actions_dictionary
PDF::Pages | dict | Count, CropBox, Kids, MediaBox, Parent, Resources, Rotate(rotate), Type(type) | add-page, add-pages, art-box, bbox, bleed, bleed-box, core-font, crop-box, delete-page, find-resource, height, images, iterate-pages, media-box, page, page-count, page-fragment, page-index, pages, pages-fragment, resource-entry, resource-key, resources, to-landscape, trim-box, use-font, use-resource, width | /Type /Pages - a node in the page tree | ISO_32000_2::Table_30-Required_entries_in_a_page_tree_node ISO_32000::Table_29-Required_entries_in_a_page_tree_node
PDF::Pattern::Shading | dict | ExtGState, Matrix, PatternType, Shading, Type |  | /ShadingType 2 - Axial | ISO_32000_2::Table_75-Entries_in_a_Type_2_pattern_dictionary ISO_32000::Table_76-Entries_in_a_Type_2_Pattern_Dictionary
PDF::Pattern::Tiling | stream | BBox, Matrix, PaintType, PatternType, Resources, TilingType, Type, XStep, YStep | bbox, canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, html-canvas, images, mcid, new-gfx, next-mcid, open, pre-gfx, pre-graphics, render, resource-entry, resource-key, resources, save-as-image, tags, text, tiling-pattern, use-font, use-mcid, use-resource, width, xobject-form | /PatternType 1 - Tiling | ISO_32000_2::Table_74-Additional_entries_specific_to_a_Type_1_pattern_dictionary ISO_32000::Table_75-Additional_Entries_Specific_to_a_Type_1_Pattern_Dictionary
PDF::Resources | dict | ColorSpace, ExtGState, Font, Pattern, ProcSet, Properties, Shading, XObject |  | Resource Dictionary | ISO_32000::Table_33-Entries_in_a_resource_dictionary ISO_32000_2::Table_34-Entries_in_a_resource_dictionary
PDF::Shading::Axial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 2 - Axial | ISO_32000_2::Table_79-Additional_entries_specific_to_a_Type_2_shading_dictionary ISO_32000::Table_80-Additional_Entries_Specific_to_a_Type_2_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::Coons | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 6 - Coons | ISO_32000_2::Table_83-Additional_entries_specific_to_a_Type_6_shading_dictionary ISO_32000::Table_84-Additional_Entries_Specific_to_a_Type_6_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::FreeForm | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 4 - FreeForm | ISO_32000_2::Table_81-Additional_entries_specific_to_a_Type_4_shading_dictionary ISO_32000::Table_82-Additional_Entries_Specific_to_a_Type_4_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::Function | dict | AntiAlias, BBox, Background, ColorSpace, Domain, Function, Matrix, ShadingType |  | /ShadingType 1 - Functional | ISO_32000_2::Table_78-Additional_entries_specific_to_a_Type_1_shading_dictionary ISO_32000::Table_79-Additional_Entries_Specific_to_a_Type_1_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::Lattice | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, ColorSpace, Decode, Function, ShadingType, VerticesPerRow |  | /ShadingType 5 - Lattice | ISO_32000_2::Table_82-Additional_entries_specific_to_a_Type_5_shading_dictionary ISO_32000::Table_83-Additional_Entries_Specific_to_a_Type_5_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::Radial | dict | AntiAlias, BBox, Background, ColorSpace, Coords, Domain, Extend, Function, ShadingType |  | /ShadingType 3 - Radial | ISO_32000_2::Table_80-Additional_entries_specific_to_a_Type_3_shading_dictionary ISO_32000::Table_81-Additional_Entries_Specific_to_a_Type_3_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Shading::Tensor | stream | AntiAlias, BBox, Background, BitsPerComponent, BitsPerCoordinate, BitsPerFlag, ColorSpace, Decode, Function, ShadingType |  | /ShadingType 7 - Tensor | ISO_32000_2::Table_83-Additional_entries_specific_to_a_Type_6_shading_dictionary ISO_32000::Table_84-Additional_Entries_Specific_to_a_Type_6_Shading_Dictionary ISO_32000::Table_78-Entries_Common_to_All_Shading_Dictionaries ISO_32000_2::Table_77-Entries_common_to_all_shading_dictionaries
PDF::Signature | dict | ByteRange, Cert, Changes, ContactInfo, Contents, Location, M(date-signed), Name, Prop_AuthTime, Prop_AuthType, Prop_Build, R, Reason, Reference, SubFilter, Type, V | byte-ranges |  | ISO_32000::Table_252-Entries_in_a_signature_dictionary ISO_32000_2::Table_255-Entries_in_a_signature_dictionary
PDF::Sound | dict | B(bits), C(channels), CO(compression-format), CP(compression-params), E(encoding), R(rate), Type |  |  | ISO_32000::Table_294-Additional_entries_specific_to_a_sound_object ISO_32000_2::Table_305-Additional_entries_specific_to_a_sound_object
PDF::StructElem | dict | A, AF, ActualText, Alt(alternative-description), C(class), E(expanded-form), ID, K(kids), Lang, NS(namespace), P(struct-parent), Pg(page), Phoneme, PhoneticAlphabet, R(revision), Ref, S(tag), T(title), Type | attribute-dicts, class-map-keys, vivify-attributes | an entry in the StructTree See also PDF::StructTreeRoot | ISO_32000::Table_323-Entries_in_a_structure_element_dictionary ISO_32000_2::Table_355-Entries_in_a_structure_element_dictionary
PDF::StructTreeRoot | dict | AF, ClassMap, IDTree, K(kids), Namespaces, ParentTree, ParentTreeNextKey, PronunciationLexicon, RoleMap, Type(type) |  |  | ISO_32000_2::Table_354-Entries_in_the_structure_tree_root ISO_32000::Table_322-Entries_in_the_structure_tree_root
PDF::ViewerPreferences | dict | CenterWindow, Direction, DisplayDocTitle, Duplex, Enforce, FitWindow, HideMenubar, HideToolbar, HideWindowUI, NonFullScreenPageMode(after-fullscreen), NumCopies, PickTrayByPDFSize, PrintArea, PrintClip, PrintPageRange, PrintScaling, ViewArea, ViewClip |  | ViewerPreferences role - see PDF::Catalog - /ViewerPreferences entry | ISO_32000::Table_150-Entries_in_a_viewer_preferences_dictionary ISO_32000_2::Table_147-Entries_in_a_viewer_preferences_dictionary
[PDF::XObject::Form](https://pdf-raku.github.io/PDF-Class-raku/PDF/XObject/Form) | stream | AF, BBox, FormType, Group, LastModified, Matrix, Measure, Metadata, Name, OC(optional-content-group), OPI, PieceInfo, PtData, Ref, Resources, StructParent, StructParents, Subtype(subtype), Type(type) | bbox, canvas, contents, contents-parse, core-font, find-resource, finish, gfx, graphics, has-pre-gfx, height, html-canvas, images, mcid, new-gfx, next-mcid, open, pre-gfx, pre-graphics, render, resource-entry, resource-key, resources, save-as-image, struct-parent, tags, text, tiling-pattern, use-font, use-mcid, use-resource, width, xobject-form | XObject Forms - /Type /XObject /Subtype Form | ISO_32000_2::Table_93-Additional_entries_specific_to_a_Type_1_form_dictionary ISO_32000::Table_95-Additional_Entries_Specific_to_a_Type_1_Form_Dictionary
[PDF::XObject::Image](https://pdf-raku.github.io/PDF-Class-raku/PDF/XObject/Image) | stream | AF, Alternates, BitsPerComponent, ColorSpace, Decode, Height, ID, ImageMask, Intent, Interpolate, Mask, Measure, Metadata, Name, OC(optional-content), OPI, PtData, SMask, SMaskInData, StructParent(struct-parent), Subtype, Type, Width | bbox, data-uri, height, image-obj, image-type, inline-content, inline-to-xobject, open, source, to-png, width | /Type XObject /Subtype /Image See [PDF 32000 Section 8.9 - Images ] | ISO_32000::Table_89-Additional_Entries_Specific_to_an_Image_Dictionary ISO_32000_2::Table_87-Additional_entries_specific_to_an_image_dictionary
[PDF::XObject::PS](https://pdf-raku.github.io/PDF-Class-raku/PDF/XObject/PS) | stream | Level1, Subtype(subtype), Type(type) |  | Postscript XObjects /Type XObject /Subtype PS See [PDF 32000 Section 8.8.2 PostScript XObjects] | ISO_32000::Table_88-Additional_Entries_Specific_to_a_PostScript_XObject_Dictionary

*(generated by `etc/make-quick-ref.pl`)*
