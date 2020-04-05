module TouchTunes.Models.Editor exposing
    ( Editor
    , editingMeasure
    , empty
    , forMeasure
    , measure
    , open
    , originalMeasure
    , setAlteration
    , setSubdivision
    , setTime
    )

import Array exposing (Array)
import Debug exposing (log)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure, modifyNote)
import Music.Models.Note exposing (Note)
import Music.Models.Pitch exposing (Semitones)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time exposing (Time)
import String
import TouchTunes.Models.Controls as Controls
import TouchTunes.Models.Overlay exposing (Overlay)


type alias Settings =
    { subdivision : Duration
    , alteration : Semitones
    , time : Time
    }


initialSettings =
    Settings
        Duration.quarter
        0
        Time.common


setSubdivision : Duration -> Settings -> Settings
setSubdivision dur settings =
    { settings | subdivision = dur }


setAlteration : Semitones -> Settings -> Settings
setAlteration semi settings =
    { settings | alteration = semi }


setTime : Time -> Settings -> Settings
setTime time settings =
    { settings | time = time }


type alias Editor =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , overlay : Maybe Overlay
    , settings : Settings
    , tracking : Controls.Tracking
    }


empty : Editor
empty =
    Editor
        Score.empty
        0
        0
        Nothing
        initialSettings
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
        Nothing
        initialSettings
        Controls.inactive


measure : Editor -> Maybe Measure
measure editor =
    let
        original =
            originalMeasure editor
    in
    log "Editor.measure editor" <|
        case editor.overlay of
            Just overlay ->
                let
                    m =
                        Maybe.map
                            (Measure.withAttributes overlay.layout.direct)
                            original
                in
                case overlay.selection of
                    Just selection ->
                        let
                            t =
                                Layout.time overlay.layout

                            fn =
                                modifyNote
                                    (\_ -> selection.note)
                                    (Beat.toDuration t selection.location.beat)
                        in
                        Maybe.map fn m

                    Nothing ->
                        m

            Nothing ->
                original


originalMeasure : Editor -> Maybe Measure
originalMeasure editor =
    Score.measure editor.partNum editor.measureNum editor.score


forMeasure : Int -> Int -> Editor -> Maybe Editor
forMeasure partNum measureNum editor =
    if
        partNum
            == editor.partNum
            && measureNum
            == editor.measureNum
    then
        Just editor

    else
        Nothing


editingMeasure : Int -> Int -> Editor -> Maybe Measure
editingMeasure partNum measureNum editor =
    case forMeasure partNum measureNum editor of
        Just ed ->
            measure editor

        Nothing ->
            Nothing
