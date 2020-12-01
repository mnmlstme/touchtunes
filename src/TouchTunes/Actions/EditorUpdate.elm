module TouchTunes.Actions.EditorUpdate exposing (update)

import Array as Array
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Harmony as Harmony
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
import Vectrol.Models.Dial as Dial
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
    case  msg of
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
                ( offset, note ) =
                    Overlay.findContinuedNote pos editor.measure editor.overlay

                overharm =
                    Overlay.editHarmony offset note.harmony editor.overlay
            in
            Editor.withOverlay overharm editor

        DragEdit pos ->
            let
                overnote =
                    Overlay.drag pos editor.overlay
            in
            Editor.withOverlay overnote editor

        EraseSelection ->
            let
                overrest =
                    Overlay.eraseSelection editor.overlay
            in
            Editor.finish <| Editor.withOverlay overrest editor

        FinishEdit ->
            Editor.finish editor

        SaveEdit ->
            Editor.commit editor

        DoneEdit ->
            Editor.commit editor

        NextNew ->
            Editor.commit editor

        NextEdit ->
            Editor.commit editor

        PreviousNew ->
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

        HarmonyMsg dialAction ->
            let
                hd =
                    Dial.update dialAction controls.harmonyDial

                ed =
                    { editor
                        | controls =
                            { controls
                                | harmonyDial = hd
                            }
                    }

                dd =
                    Dial.update dialAction controls.chordDial

                mHarm =
                    Maybe.map
                        (\h -> Harmony.setDegree dd.value h)
                        hd.value
            in
            case dialAction of
                Dial.Finish ->
                    commit <|
                        Editor.withOverlay
                            (Overlay.changeHarmony mHarm overlay)
                            ed

                _ ->
                    ed

        KindMsg dialAction ->
            let
                kd =
                    Dial.update dialAction controls.kindDial

                kind = Dial.value kd

                degree = Dial.value controls.chordDial

                h = Maybe.map
                    (\harm -> Harmony.setDegree degree <| Harmony.setKind kind harm)
                    <| Dial.value controls.harmonyDial

                ed =
                    { editor
                        | controls =
                            { controls
                                | kindDial = kd
                                , harmonyDial = Dial.override h controls.harmonyDial
                            }
                    }

            in
            case dialAction of
                Dial.Finish ->
                    commit ed

                _ ->
                    ed

        DegreeMsg dialAction ->
            let
                cd =
                    Dial.update dialAction controls.chordDial

                degree = Dial.value cd

                h = Maybe.map (Harmony.setDegree degree) <| Dial.value controls.harmonyDial

                ed =
                    { editor
                        | controls =
                            { controls
                                | chordDial = cd
                                , harmonyDial = Dial.override h controls.harmonyDial
                            }
                    }
            in
            case dialAction of
                Dial.Finish ->
                    commit ed

                _ ->
                    ed

        AltHarmonyMsg dialAction ->
            let
                ad =
                    Dial.update dialAction controls.altHarmonyDial

                alt = Dial.value ad

                h = Maybe.map (Harmony.setAlteration alt) <| Dial.value controls.harmonyDial

                ed =
                    { editor
                        | controls =
                            { controls
                                | altHarmonyDial = ad
                                , harmonyDial = Dial.override h controls.harmonyDial
                            }
                    }

            in
            case dialAction of
                Dial.Finish ->
                    commit ed

                _ ->
                    ed

        BassMsg dialAction ->
            let
                bd =
                    Dial.update dialAction controls.bassDial

                bass = Dial.value bd

                h = Maybe.map (Harmony.over bass) <| Dial.value controls.harmonyDial

                ed =
                    { editor
                        | controls =
                            { controls
                                | bassDial = bd
                                , harmonyDial = Dial.override h controls.harmonyDial
                            }
                    }

            in
            case dialAction of
                Dial.Finish ->
                    commit ed

                _ ->
                    ed

        _ ->
            editor
