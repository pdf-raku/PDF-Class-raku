[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



ViewerPreferences role - see PDF::Catalog - /ViewerPreferences entry

### has Bool $.HideToolbar

(Optional) A flag specifying whether to hide the viewer application’s tool bars when the document is active. Default value: false.

### has Bool $.HideMenubar

(Optional) A flag specifying whether to hide the viewer application’s menu bar when the document is active. Default value: false.

### has Bool $.HideWindowUI

(Optional) A flag specifying whether to hide user interface elements in the document’s window (such as scroll bars and navigation controls), leaving only the document’s contents displayed. Default value: false.

### has Bool $.FitWindow

(Optional) A flag specifying whether to resize the document’s window to fit the size of the first displayed page. Default value: false

### has Bool $.CenterWindow

(Optional; PDF 1.4) A flag specifying whether the window’s title bar should display the document title taken from the Title entry of the document information dictionary. If false, the title bar should instead display the name of the PDF file containing the document. Default value: false.

### has Bool $.DisplayDocTitle

(Optional; PDF 1.4) A flag specifying whether the window’s title bar should display the document title taken from the Title entry of the document information dictionary. If false, the title bar should instead display the name of the PDF file containing the document. Default value: false.

### has PDF::ViewerPreferences::PageModes $.NonFullScreenPageMode

(Optional) The document’s page mode, specifying how to display the document on exiting full-screen mode:

### has PDF::COS::Name $.ViewArea

(Optional; PDF 1.4) The name of the page boundary representing the area of a page to be displayed when viewing the document on the screen. The value is the key designating the relevant page boundary in the page object (see “Page Objects” on page 144 and Section 10.10.1, “Page Boundaries”). If the specified page boundary is not defined in the page object, its default value is used, as specified in Table 3.27 on page 145. Default value: CropBox.

### has PDF::COS::Name $.ViewClip

(Optional; PDF 1.4) The name of the page boundary to which the contents of a page are to be clipped when viewing the document on the screen. The value is the key designating the relevant page boundary in the page object (see “Page Objects” on page 144 and Section 10.10.1, “Page Boundaries”). If the specified page boundary is not defined in the page object, its default value is used, as specified in Table 3.27 on page 145. Default value: CropBox.

### has PDF::COS::Name $.PrintClip

(Optional; PDF 1.4; deprecated in PDF 2.0) The name of the page boundary to which the contents of a page is clipped when printing the document.

### has PDF::COS::Name $.PrintArea

(Optional; PDF 1.4) The name of the page boundary representing the area of a page to be rendered when printing the document. The value is the key designating the relevant page boundary in the page object (see “Page Objects” on page 144 and Section 10.10.1, “Page Boundaries”). If the specified page boundary is not defined in the page object, its default value is used, as specified in Table 3.27 on page 145. Default value: CropBox.

### has PDF::COS::Name $.PrintScaling

(Optional; PDF 1.6) The page scaling option to be selected when a print dialog is displayed for this document. Valid values are None, which indicates that the print dialog should reflect no page scaling, and AppDefault, which indicates that applications should use the current print scaling. If this entry has an unrecognized value, applications should use the current print scaling. Default value: AppDefault.

### has PDF::ViewerPreferences::PageHandling $.Duplex

(Optional; PDF 1.7) The paper handling option to use when printing the file from the print dialog.

### has Bool $.PickTrayByPDFSize

(Optional; PDF 1.7) A flag specifying whether the PDF page size is used to select the input paper tray. This setting influences only the preset values used to populate the print dialog presented by a PDF viewer application. If PickTrayByPDFSize is true, the check box in the print dialog associated with input paper tray is checked.

### has Positional[UInt] @.PrintPageRange

(Optional; PDF 1.7) The page numbers used to initialize the print dialog box when the file is printed. The first page of the PDF file is denoted by 1. Each pair consists of the first and last pages in the sub-range. An odd number of integers causes this entry to be ignored. Negative numbers cause the entire array to be ignored.

### has UInt $.NumCopies

(Optional; PDF 1.7) The number of copies to be printed when the print dialog is opened for this file. Supported values are the integers 2 through 5. Values outside this range are ignored.

### has Positional[PDF::ViewerPreferences::Enforcable] @.Enforce

(Optional; PDF 2.0) An array of names of Viewer preference settings that shall be enforced by PDF processors and that shall not be overridden by subsequent selections in the application user interface.

