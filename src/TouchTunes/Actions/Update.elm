module TouchTunes.Actions.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key
    exposing
        ( Key
        , Mode(..)
        , keyName
        , keyOf
        , stepNumberToPitch
        )
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Note exposing (Note, What(..))
import Music.Models.Pitch exposing (Pitch, Semitones, stepNumber)
import Music.Models.Score as Score
import Music.Models.Staff as Staff
import Music.Models.Time as Time
import Music.Views.MeasureView as MeasureView
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.Controls as Controls
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Editor as Editor
    exposing
        ( Editor
        , commit
        )
import TouchTunes.Models.Overlay as Overlay


update : Msg -> Editor -> Editor
update msg editor =
    let
        controls =
            editor.controls

        subdivisions =
            Dial.value controls.subdivisionDial

        overlay =
            Overlay.subdivide subdivisions editor.overlay
    in
    case log "Editor got msg" msg of
        StartEdit _ _ attributes measure ->
            Editor.open attributes measure

        NoteEdit pos ->
            let
                mNote =
                    Overlay.findNote pos editor.measure editor.overlay

                overnote =
                    case mNote of
                        Just note ->
                            Overlay.editNote pos note editor.overlay

                        Nothing ->
                            Overlay.startNote pos editor.overlay
            in
            Editor.withOverlay overnote editor

        HarmonyEdit pos ->
            let
                mNote =
                    Overlay.findNote pos editor.measure editor.overlay

                mHarmony =
                    Maybe.andThen .harmony mNote

                overharm =
                    case mHarmony of
                        Just harmony ->
                            Overlay.editHarmony pos harmony editor.overlay

                        Nothing ->
                            Overlay.startHarmony pos editor.overlay
            in
            Editor.withOverlay overharm editor

        DragEdit pos ->
            let
                overnote =
                    Overlay.drag pos editor.overlay
            in
            Editor.withOverlay overnote editor

        FinishEdit ->
            Editor.finish editor

        SaveEdit ->
            Editor.commit editor

        DoneEdit ->
            Editor.commit editor

        NextEdit ->
            Editor.commit editor

        PreviousEdit ->
            Editor.commit editor

        CancelEdit ->
            { editor | overlay = Overlay.deselect editor.overlay }

        SubdivisionMsg dialAction ->
            commit
                { editor
                    | controls =
                        { controls
                            | subdivisionDial =
                                Dial.update dialAction controls.subdivisionDial
                        }
                }

        AlterationMsg dialAction ->
            { editor
                | controls =
                    { controls
                        | alterationDial =
                            Dial.update dialAction controls.alterationDial
                    }
            }

        TimeMsg dialAction ->
            commit
                { editor
                    | controls =
                        { controls
                            | timeDial =
                                Dial.update dialAction controls.timeDial
                        }
                }

        KeyMsg dialAction ->
            commit
                { editor
                    | controls =
                        { controls
                            | keyDial =
                                Dial.update dialAction controls.keyDial
                        }
                }

        RootMsg dialAction ->
            commit
                { editor
                    | controls =
                        { controls
                            | rootDial =
                                Dial.update dialAction controls.rootDial
                        }
                }
