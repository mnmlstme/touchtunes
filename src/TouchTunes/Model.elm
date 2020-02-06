module TouchTunes.Model exposing
    ( Editor
    , empty
    , open
    )

import Array exposing (Array)
import Music.Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Model exposing (Measure)
import Music.Pitch exposing (Semitones)
import Music.Score.Model as Score exposing (Score)
import String
import TouchTunes.Controls as Controls


type alias Editor =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , measure : Maybe Measure
    , savedMeasure : Maybe Measure
    , selection : Maybe Beat
    , durationSetting : Duration
    , alterationSetting : Semitones
    , tracking : Controls.Tracking
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
        0
        Controls.inactive


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
        0
        Controls.inactive
