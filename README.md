# sml-indent

[![This project is considered experimental](https://img.shields.io/badge/status-experimental-critical.svg)](https://benknoble.github.io/status/experimental/)

This is an SML program that indents SML code.  It is fast enough to rebind TAB
to indent the entire file.  A 23k line file (hamlet.sml in the tests
directory) takes about .3 seconds to indent.

## Misc

Symbols can pop multiple stack elements; e.g., the second `val` pops the
context of the first val.

```sml
val x = 5
val y = 5
```

## Indenting comments:

```sml
(*
    foo works like this
*)
fun foo x =
```

```sml
(*
    foo works like this *)
fun foo x =
```

```sml
(*
    foo works like this
       and this
*)
fun foo x =
```

## Problems with indent.sml I don't care about.

```sml
fun f x = 5
  | f y =
   5
```

I don't use `fun` for pattern matching.  I only use `fn` for this. Examples:

```sml
val f = fn x => x
 | y = 6
```

I'd write

```sml
val f = fn
   x => x
 | y = 6
```

```sml
val f = case f
   x
   of
   x => 5
 | y => 6
```

I'd write

```sml
val f =
  case
    f x
  of x => 5
   | y => 6
```

```sml
val _ =
   5
   handle A => 6
    | B => 7
```

I'd write

```sml
val _ =
   5
   handle
      A => 6
    | B => 7
```

```sml
if a then b
else if c
   orelse d
then e
else f
```

This is hard to fix. We'd want

```sml
if a then b
else if c
        orelse d
then e
else f
```

but this would make the `andalso`/`orelse` handling much more difficult. Both
alternatives work:

```sml
if a then b
else
if c
orelse d
then e
else f
```

```sml
if a then b
else if
   c
   orelse d
then e
else f
```
