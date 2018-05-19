use v6;

use PDF::XObject;
use PDF::Image;

#| XObjects
#| /Type XObject /Subtype /Image
#| See [PDF 1.7 Section 4.8 - Images ]
class PDF::XObject::Image
    is PDF::XObject
    does PDF::Image {

}
