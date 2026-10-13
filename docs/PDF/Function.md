[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

class PDF::Function
-------------------

/FunctionType 1..7 - the Function dictionary delegates

### has Positional[Numeric] @.Domain

(Required) An array of 2 × m numbers, where m is the number of input values. For each i from 0 to m − 1

### has Positional[Numeric] @.Range

(Required for type 0 and type 4 functions, optional otherwise; see below) An array of 2 × n numbers, where n is the number of output values.

### method delegate-function

```raku
method delegate-function(
    Hash :$dict!
) returns Mu
```

see also PDF::Class::Loader

