[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)



/ShadingType 1..7 - the Shading dictionary delegates

### has PDF::Class::Defs::ColorSpace $.ColorSpace

(Required) The color space in which color values are expressed.

### has Positional @.Background

(Optional) An array of color components appropriate to the color space, specifying a single background color value.

### has Positional[Numeric] @.BBox

(Optional) An array of four numbers giving the left, bottom, right, and top coordinates, respectively, of the shading’s bounding box

### has Bool $.AntiAlias

(Optional) A flag indicating whether to filter the shading function to prevent aliasing artifacts.

### method delegate-shading

```raku
method delegate-shading(
    Hash :$dict!,
    |c
) returns Mu
```

see also PDF::Class::Loader

