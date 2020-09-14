module TouchTunes.Views.Symbols exposing (subdivideOne, subdivideTwo, subdivideFour)

import Music.Views.Symbols exposing (Symbol, ViewBox)


-- Symbol definitions for symbols in sprite from ./svg folder


subdivideOne =
    Symbol (ViewBox 0 0 64 60) "tt-subdivide-1"

subdivideTwo =
    Symbol (ViewBox 0 0 64 60) "tt-subdivide-2"

subdivideFour =
    Symbol (ViewBox 0 0 64 60) "tt-subdivide-4"
