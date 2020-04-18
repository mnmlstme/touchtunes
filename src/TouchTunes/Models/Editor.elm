module TouchTunes.Models.Editor exposing
    ( Editor
    , commit
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
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Controls as Controls exposing (Controls)
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Overlay as Overlay exposing (Overlay)


type alias Editor =
    { score : Score
    , partNum : Int
    , measureNum : Int
    , controls : Controls Msg
    , overlay : Overlay
    }


open : Int -> Int -> Layout -> Score -> Editor
open pnum mnum layout score =
    let
        maybeMeasure =
            Score.measure pnum mnum score
    in
    Editor
        score
        pnum
        mnum
        -- TODO: initialize controls from measure
        Controls.init
        (Overlay.fromLayout layout)


commit : Editor -> Editor
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
                , overlay = adjustOverlay theMeasure editor.controls editor.overlay
            }

        Nothing ->
            editor


adjustOverlay : Measure -> Controls Msg -> Overlay -> Overlay
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


measure : Editor -> Maybe Measure
measure editor =
    let
        original =
            originalMeasure editor

        layout =
            editor.overlay.layout

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
    log "Editor.measure editor" <|
        case editor.overlay.selection of
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


originalMeasure : Editor -> Maybe Measure
originalMeasure editor =
    Score.measure editor.partNum editor.measureNum editor.score



-- forMeasure : Int -> Int -> Editor -> Maybe Editor
-- forMeasure partNum measureNum editor =
--     if
--         partNum
--             == editor.partNum
--             && measureNum
--             == editor.measureNum
--     then
--         Just editor
--
--     else
--         Nothing
--
--
-- editingMeasure : Int -> Int -> Editor -> Maybe Measure
-- editingMeasure partNum measureNum editor =
--     case forMeasure partNum measureNum editor of
--         Just ed ->
--             measure editor
--
--         Nothing ->
--             Nothing
