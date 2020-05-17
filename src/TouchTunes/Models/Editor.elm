module TouchTunes.Models.Editor exposing
    ( Editor
    , commit
    , finish
    , latent
    , open
    , withOverlay
    )

import Array exposing (Array)
import Debug exposing (log)
import Maybe.Extra
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key exposing (Key, KeyName(..), Mode(..), keyOf)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Attributes, Measure, modifyNote)
import Music.Models.Note as Note exposing (Note)
import Music.Models.Pitch as Pitch exposing (Semitones)
import Music.Models.Time as Time exposing (Time)
import String
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Controls as Controls exposing (Controls)
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Overlay as Overlay exposing (Overlay, Selection(..))


type alias Editor =
    { measure : Measure
    , controls : Controls Msg
    , overlay : Overlay
    }


open : Attributes -> Measure -> Editor
open indirect measure =
    let
        layout =
            Layout.forMeasure indirect measure
    in
    Editor
        measure
        (Controls.init (Just layout))
        (Overlay.fromLayout layout)


withOverlay : Overlay -> Editor -> Editor
withOverlay overlay editor =
    let
        controls =
            Controls.forSelection overlay.selection editor.controls
    in
    { editor
        | overlay = overlay
        , controls = controls
    }


commit : Editor -> Editor
commit editor =
    let
        theMeasure =
            latent editor

        overlay =
            editor.overlay

        newLayout =
            Layout.forMeasure overlay.layout.indirect theMeasure

        dur =
            Dial.value editor.controls.subdivisionDial
    in
    { editor
        | measure =
            log "commit" theMeasure
        , overlay = Overlay.subdivide dur { overlay | layout = newLayout }
    }


finish : Editor -> Editor
finish editor =
    commit { editor | overlay = Overlay.finish editor.overlay }


latent : Editor -> Measure
latent editor =
    let
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
            override editor.measure
    in
    -- log "Editor.latent editor" <|
    case log "selection" editor.overlay.selection of
        HarmonySelection harmony beat ->
            let
                t =
                    Layout.time layout

                h =
                    { harmony
                        | root = editor.controls.rootDial.value
                    }

                fn =
                    modifyNote
                        (\original -> { original | harmony = Just h })
                        (Beat.toDuration t beat)
            in
            fn controlled

        NoteSelection note location _ ->
            let
                t =
                    Layout.time layout

                alteration =
                    Dial.value editor.controls.alterationDial

                changed =
                    Note.modPitch (Pitch.setAlter alteration) note

                replace n orig =
                    { n | harmony = orig.harmony }

                fn =
                    modifyNote
                        (\original -> replace changed original)
                        (Beat.toDuration t location.beat)
            in
            fn controlled

        NoSelection ->
            controlled
