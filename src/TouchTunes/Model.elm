module TouchTunes.Model exposing
    ( Editor
    , editingMeasure
    , empty
    , measure
    , open
    , originalMeasure
    )

import Array exposing (Array)
import Debug exposing (log)
import Music.Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Layout as Layout exposing (Layout)
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
    , layout : Maybe Layout
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
        Nothing
        Duration.quarter
        0
        Controls.inactive


open : Score -> Editor
open score =
    let
        maybeMeasure =
            Score.measure 0 0 score

        maybeLayout =
            Maybe.map
                (\m -> Layout.forMeasure m.attributes m)
                maybeMeasure
    in
    Editor
        score
        0
        0
        maybeLayout
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
            Maybe.withDefault was <|
                log "editor.selection" editor.selection
    in
    log "Editor.measure editor" <|
        case editor.cursor of
            Just cursor ->
                case editor.layout of
                    Just layout ->
                        let
                            fn =
                                modifyNote modifier (Layout.time layout) cursor
                        in
                        Maybe.map fn m

                    Nothing ->
                        m

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
