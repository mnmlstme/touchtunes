module Example1 exposing (..)

import Music.Score exposing (Score)
import Music.Part exposing (Part)
import Music.Measure exposing (Measure)


example : Score
example =
    Score "Example One"
        [ Part
            "Piano"
            "Pno."
            [ Measure [ "do", "re", "mi" ]
            , Measure [ "fa", "so", "la" ]
            , Measure [ "ti", "do" ]
            ]
        ]
