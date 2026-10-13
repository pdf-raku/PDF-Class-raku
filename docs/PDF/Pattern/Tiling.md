[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Pattern::Tiling
--------------------------

/PatternType 1 - Tiling

### has PDF::Pattern::Tiling::PaintCode $.PaintType

(Required) A code that determines how the color of the pattern cell is to be specified:

### has PDF::Pattern::Tiling::TilingCode $.TilingType

(Required) A code that controls adjustments to the spacing of tiles relative to the device pixel grid:

### has Positional[Numeric] @.BBox

(Required) An array of four numbers in the pattern coordinate system giving the coordinates of the left, bottom, right, and top edges, respectively, of the pattern cell’s bounding box. These boundaries are used to clip the pattern cell.

### has Numeric $.XStep

(Required) The desired horizontal spacing between pattern cells, measured in the pattern coordinate system.

### has Numeric $.YStep

(Required) The desired vertical spacing between pattern cells, measured in the pattern coordinate system.

### has PDF::Resources $.Resources

(Required) A resource dictionary containing all of the named resources required by the pattern’s content stream.

