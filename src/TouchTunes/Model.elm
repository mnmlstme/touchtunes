module TouchTunes.Model exposing
    ( Editor
    , editingMeasure
    , empty
    , measure
    , open
    , originalMeasure
    )

import Array exposing (Array)
import Music.Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Semitones)
import Music.Score.Model as Score exposing (Score)
import String
import TouchTunes.Controls as Controls


type alias Editor =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , cursor : Maybe Beat
    , selection : Maybe Note
    , subdivisionSetting : Duration
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
        Duration.quarter
        0
        Controls.inactive


measure : Editor -> Maybe Measure
measure editor =
    let
        m =
            originalMeasure editor

        modifier was =
            Maybe.withDefault was editor.selection
    in
    case editor.cursor of
        Just cursor ->
            Maybe.map (modifyNote modifier cursor) m

        Nothing ->
            m


originalMeasure : Editor -> Maybe Measure
originalMeasure editor =
    Score.measure editor.partNum editor.measureNum editor.score


editingMeasure : Editor -> Int -> Int -> Maybe Measure
editingMeasure editor partNum measureNum =
    if
        partNum
            == editor.partNum
            && measureNum
            == editor.measureNum
    then
        measure editor

    else
        Nothing
