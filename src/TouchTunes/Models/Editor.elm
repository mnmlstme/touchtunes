module TouchTunes.Models.Editor exposing
    ( Editor
    , commit
    , editingMeasure
    , forMeasure
    , init
    , measure
    , open
    , originalMeasure
    )

import Array exposing (Array)
import Debug exposing (log)
import Maybe.Extra
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key exposing (Key, KeyName(..), Mode(..), keyOf)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure, modifyNote)
import Music.Models.Note exposing (Note)
import Music.Models.Pitch exposing (Semitones)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time exposing (Time)
import String
import TouchTunes.Models.Controls as Controls exposing (Controls)
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Overlay as Overlay exposing (Overlay)


type alias Editor msg =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , controls : Controls msg
    , overlay : Maybe Overlay
    }


init : Editor msg
init =
    Editor
        Score.empty
        0
        0
        Controls.init
        Nothing


open : Score -> Editor msg
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
        Controls.init
        Nothing


commit : Editor msg -> Editor msg
commit editor =
    case measure editor of
        Just theMeasure ->
            { editor
                | score =
                    Score.setMeasure
                        editor.partNum
                        editor.measureNum
                        (log "commit" theMeasure)
                        editor.score
                , overlay = Maybe.map (adjustOverlay theMeasure editor.controls) editor.overlay
            }

        Nothing ->
            editor


adjustOverlay : Measure -> Controls msg -> Overlay -> Overlay
adjustOverlay newMeasure controls overlay =
    let
        indirect =
            overlay.layout.indirect

        newLayout =
            Layout.forMeasure indirect newMeasure

        dur =
            Dial.value controls.subdivisionDial
    in
    Overlay.subdivide dur { overlay | layout = newLayout }


measure : Editor msg -> Maybe Measure
measure editor =
    let
        original =
            originalMeasure editor
    in
    log "Editor.measure editor" <|
        case editor.overlay of
            Just overlay ->
                let
                    layout =
                        overlay.layout

                    override m =
                        let
                            direct =
                                m.attributes
                        in
                        Measure.withEssentialAttributes
                            layout.indirect
                            { direct
                                | time = Just editor.controls.timeDial.value
                                , key = Just <| keyOf editor.controls.keyDial.value Major
                            }
                            m

                    controlled =
                        Maybe.map override original
                in
                case overlay.selection of
                    Just selection ->
                        let
                            t =
                                Layout.time layout

                            fn =
                                modifyNote
                                    (\_ -> selection.note)
                                    (Beat.toDuration t selection.location.beat)
                        in
                        Maybe.map fn controlled

                    Nothing ->
                        controlled

            Nothing ->
                original


originalMeasure : Editor msg -> Maybe Measure
originalMeasure editor =
    Score.measure editor.partNum editor.measureNum editor.score


forMeasure : Int -> Int -> Editor msg -> Maybe (Editor msg)
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


editingMeasure : Int -> Int -> Editor msg -> Maybe Measure
editingMeasure partNum measureNum editor =
    case forMeasure partNum measureNum editor of
        Just ed ->
            measure editor

        Nothing ->
            Nothing
