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
import Music.Note.Model exposing (heldFor)
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
                        [ f 4 |> heldFor quarter
                        , a 4 |> heldFor quarter
                        , c 5 |> heldFor half
                        ]
                    , Measure
                        [ (flat e_) 4 |> heldFor half
                        , g 4 |> heldFor half
                        ]
                    , Measure
                        [ (flat b) 4 |> heldFor whole
                        ]
                    , Measure
                        [ d 4 |> heldFor quarter
                        , (sharp f) 4 |> heldFor half
                        , a 4 |> heldFor quarter
                        , d 5 |> heldFor quarter
                        ]
                    ]
            ]
