module Example1 exposing (example)

import Music.Score exposing (Score, score)
import Music.Part exposing (part)
import Music.Measure exposing (measure)
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
    score "Example One"
        [ part
            "Piano"
            "Pno."
            [ measure
                [ f 4 |> heldFor quarter
                , a 4 |> heldFor quarter
                , c 5 |> heldFor quarter
                , f 5 |> heldFor quarter
                ]
            , measure
                [ (flat e_) 4 |> heldFor quarter
                , g 4 |> heldFor quarter
                , (flat b) 4 |> heldFor quarter
                , (flat e_) 5 |> heldFor quarter
                ]
            , measure
                [ d 4 |> heldFor quarter
                , (sharp f) 4 |> heldFor quarter
                , a 4 |> heldFor quarter
                , d 5 |> heldFor quarter
                ]
            ]
        ]
