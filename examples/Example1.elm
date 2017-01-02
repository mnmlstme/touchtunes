module Example1 exposing (example)

import Music.Score exposing (Score)
import Music.Part exposing (Part)
import Music.Measure exposing (Measure)
import Music.Pitch
    exposing
        ( a
        , b
        , c
        , d
        , e_
        , f
        , g
        , flat
        , sharp
        , doubleSharp
        , doubleFlat
        )
import Music.Duration exposing (quarter, half, dotted)
import Music.Note exposing (heldFor)


example : Score
example =
    Score "Example One"
        [ Part
            "Piano"
            "Pno."
            [ Measure
                [ c 4 |> heldFor quarter
                , d 4 |> heldFor half
                , e_ 4 |> heldFor quarter
                ]
            , Measure
                [ (flat b) 5 |> heldFor quarter
                , f 6 |> heldFor quarter
                , (sharp c) 5 |> heldFor quarter
                ]
            , Measure
                [ (doubleSharp c) 3 |> heldFor (dotted half)
                , (doubleFlat d) 3 |> heldFor quarter
                ]
            ]
        ]
