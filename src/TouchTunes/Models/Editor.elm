module TouchTunes.Models.Editor exposing
    ( Editor
    , commit
    , finish
    , latent
    , open
    )

import Array exposing (Array)
import Debug exposing (log)
import Maybe.Extra
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key exposing (Key, KeyName(..), Mode(..), keyOf)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Attributes, Measure, modifyNote)
import Music.Models.Note exposing (Note)
import Music.Models.Pitch exposing (Semitones)
import Music.Models.Time as Time exposing (Time)
import String
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Controls as Controls exposing (Controls)
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Overlay as Overlay exposing (Overlay)


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
        (Controls.init (Just measure))
        (Overlay.fromLayout layout)


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
    log "Editor.current editor" <|
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
                fn controlled

            Nothing ->
                controlled
