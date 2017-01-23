module Example1 exposing (example)

import Music.Score exposing (Score)
import Music.Part exposing (Part)
import Music.Measure.Model exposing (Measure)
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
import Music.Duration exposing (quarter, half, whole)
import Music.Note.Model exposing (heldFor, rest)
import Array


example : Score
example =
    Score "Example One" <|
        Array.fromList
            [ Part
                "Piano"
                "Pno."
              <|
                Array.fromList
                    [ Measure
                        [ rest quarter
                        , f 4 |> heldFor quarter
                        , a 4 |> heldFor quarter
                        , c 5 |> heldFor quarter
                        ]
                    , Measure
                        [ (flat e_) 4 |> heldFor half
                        , rest half
                        ]
                    , Measure
                        [ (sharp f) 4 |> heldFor whole
                        ]
                    , Measure
                        [ rest whole
                        ]
                    ]
            ]
