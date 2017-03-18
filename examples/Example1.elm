module Example1 exposing (example)

import Music.Score exposing (Score)
import Music.Part exposing (Part)
import Music.Measure.Model as Measure
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
import Music.Note.Model exposing (playFor, restFor)
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
                    [ Measure.fromNotes
                        [ restFor quarter
                        , f 4 |> playFor quarter
                        , a 4 |> playFor quarter
                        , c 5 |> playFor quarter
                        ]
                    , Measure.fromNotes
                        [ (flat e_) 4 |> playFor half
                        , restFor half
                        ]
                    , Measure.fromNotes
                        [ (sharp f) 4 |> playFor whole
                        ]
                    , Measure.fromNotes
                        [ restFor whole
                        ]
                    ]
            ]
