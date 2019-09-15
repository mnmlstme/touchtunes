module TouchTunes.Model exposing
    ( Editor
    , empty
    , open
    )

import Array exposing (Array)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Model exposing (Measure)
import Music.Score.Model as Score exposing (Score)
import Music.Time exposing (Beat)
import String


type alias Editor =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , measure : Maybe Measure
    , savedMeasure : Maybe Measure
    , selection : Maybe Beat
    , durationSetting : Duration
    }


empty : Editor
empty =
    Editor
        Score.empty
        0
        0
        Nothing
        Nothing
        Nothing
        Duration.quarter


open : Score -> Editor
open score =
    Editor
        score
        0
        0
        Nothing
        Nothing
        Nothing
        Duration.quarter