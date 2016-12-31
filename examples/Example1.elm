module Example1 exposing (..)

import Music.Score as Score exposing (Score)
import Music.Part as Part exposing (Part)


example : Score
example =
    Score "Example One"
        [ Part "Piano" "Pno." ]
