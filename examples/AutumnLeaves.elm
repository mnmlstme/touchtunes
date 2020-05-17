module AutumnLeaves exposing (score)

import Array
import Music.Models.Duration exposing (dotted, eighth, half, quarter, whole)
import Music.Models.Harmony
    exposing
        ( Chord(..)
        , dominant
        , halfDiminished
        , lowered
        , major
        , minor
        )
import Music.Models.Key as Key exposing (keyOf)
import Music.Models.Measure as Measure
import Music.Models.Note exposing (harmonize, playFor, restFor)
import Music.Models.Part exposing (part)
import Music.Models.Pitch
    exposing
        ( Chromatic(..)
        , Step(..)
        , a
        , b
        , c
        , d
        , doubleFlat
        , doubleSharp
        , e_
        , f
        , flat
        , g
        , root
        , sharp
        )
import Music.Models.Score exposing (Score)
import Music.Models.Staff as Staff
import Music.Models.Time as Time


score : Score
score =
    Score "Autumn Leaves"
        [ part "Piano" "Pno." ]
    <|
        Array.fromList
            [ Measure.fromNotes
                (Measure.Attributes
                    (Just Staff.treble)
                    (Just Time.cut)
                    (Just (keyOf Key.E Key.Minor))
                )
                [ restFor half
                , restFor eighth
                    |> harmonize (root B Natural |> dominant Seventh)
                , e_ 4 |> playFor eighth
                , sharp f 4 |> playFor eighth
                , g 4 |> playFor eighth
                ]
            , Measure.fromNotes Measure.noAttributes
                [ c 5
                    |> playFor half
                    |> harmonize (root A Natural |> minor Seventh)
                , restFor eighth
                    |> harmonize (root D Natural |> dominant Seventh)
                , d 4 |> playFor eighth
                , e_ 4 |> playFor eighth
                , sharp f 4 |> playFor eighth
                ]
            , Measure.fromNotes Measure.noAttributes
                [ b 4
                    |> playFor quarter
                    |> harmonize (root G Natural |> major Seventh)
                , b 4
                    |> playFor quarter
                , restFor eighth
                    |> harmonize (root C Natural |> major Seventh)
                , c 4 |> playFor eighth
                , d 4 |> playFor eighth
                , e_ 4 |> playFor eighth
                ]
            , Measure.fromNotes Measure.noAttributes
                [ a 4
                    |> playFor half
                    |> harmonize (root F Sharp |> minor Seventh |> lowered 5)
                , restFor eighth
                    |> harmonize (root B Natural |> dominant Ninth)
                , b 3 |> playFor eighth
                , sharp c 4 |> playFor eighth
                , sharp d 4 |> playFor eighth
                ]
            , Measure.fromNotes Measure.noAttributes
                [ g 4
                    |> playFor half
                    |> harmonize (root E Natural |> minor Seventh)
                , restFor eighth
                , e_ 4 |> playFor eighth
                , sharp f 4 |> playFor eighth
                , g 4 |> playFor eighth
                ]
            ]
