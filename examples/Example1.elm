module Example1 exposing (example)

import Array
import Music.Duration exposing (dotted, eighth, half, quarter, whole)
import Music.Measure.Model as Measure
import Music.Note.Model exposing (playFor, restFor)
import Music.Part.Model exposing (Part)
import Music.Pitch
    exposing
        ( a
        , b
        , c
        , d
        , doubleFlat
        , doubleSharp
        , e_
        , f
        , flat
        , g
        , sharp
        )
import Music.Score.Model exposing (Score)
import Music.Staff.Model as Staff
import Music.Time as Time


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
                        (Measure.Attributes
                            (Just Staff.treble)
                            (Just Time.common)
                        )
                        [ a 3 |> playFor quarter
                        , a 4 |> playFor quarter
                        , a 5 |> playFor quarter
                        , f 4 |> playFor eighth
                        , c 5 |> playFor eighth
                        ]
                    , Measure.fromNotes
                        Measure.noAttributes
                        [ flat e_ 4 |> playFor half
                        , sharp c 5 |> playFor (dotted quarter)
                        , restFor eighth
                        ]
                    , Measure.fromNotes
                        Measure.noAttributes
                        [ restFor half
                        , f 4 |> playFor eighth
                        , restFor (dotted quarter)
                        ]
                    , Measure.fromNotes
                        Measure.noAttributes
                        [ sharp f 4 |> playFor whole
                        ]
                    , Measure.fromNotes
                        Measure.noAttributes
                        [ restFor whole
                        ]
                    ]
            ]
