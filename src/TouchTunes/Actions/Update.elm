module TouchTunes.Actions.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Models.Beat as Beat exposing (Beat, durationFrom)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key exposing (Key, Mode(..), keyName, keyOf)
import Music.Models.Layout as Layout
    exposing
        ( locationAfter
        , positionToLocation
        )
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Note exposing (Note, What(..))
import Music.Models.Pitch exposing (Pitch, Semitones, fromStepNumber, stepNumber)
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


update : Msg -> Editor msg -> Editor msg
update msg editor =
    let
        controls =
            editor.controls

        subdivisions =
            Dial.value controls.subdivisionDial
    in
    case log "msg" msg of
        StartEdit partNum measureNum layout ->
            { editor
                | partNum = partNum
                , measureNum = measureNum
                , overlay =
                    Just <|
                        Overlay.subdivide subdivisions <|
                            Overlay.fromLayout layout
            }

        NoteEdit pos ->
            case editor.overlay of
                Just overlay ->
                    { editor
                        | overlay =
                            Just <|
                                Overlay.start subdivisions pos overlay
                    }

                Nothing ->
                    editor

        DragEdit pos ->
            case editor.overlay of
                Just overlay ->
                    { editor
                        | overlay =
                            Just <|
                                Overlay.drag subdivisions pos overlay
                    }

                Nothing ->
                    editor

        CommitEdit ->
            commit { editor | overlay = Maybe.map Overlay.finish editor.overlay }

        CancelEdit ->
            { editor | overlay = Maybe.map Overlay.deselect editor.overlay }

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
