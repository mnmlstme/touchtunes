module TouchTunes.Actions.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Models.Beat as Beat exposing (Beat, durationFrom)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Layout as Layout
    exposing
        ( locationAfter
        , positionToLocation
        )
import Music.Models.Measure exposing (Measure)
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
        , setAlteration
        , setSubdivision
        )
import TouchTunes.Models.Overlay as Overlay


commit : Editor -> Editor
commit editor =
    { editor
        | score =
            case Editor.measure editor of
                Just theMeasure ->
                    Score.setMeasure
                        editor.partNum
                        editor.measureNum
                        (log "commit" theMeasure)
                        editor.score

                Nothing ->
                    editor.score
    }


update : Msg -> Editor -> Editor
update msg editor =
    let
        tracking =
            editor.tracking

        activateSubdivisionDial activation =
            { tracking | subdivisionDial = activation }

        activateAlterationDial activation =
            { tracking | alterationDial = activation }
    in
    case log "msg" msg of
        StartEdit partNum measureNum layout ->
            { editor
                | partNum = partNum
                , measureNum = measureNum
                , overlay =
                    Just <|
                        Overlay.subdivide editor.settings.subdivision <|
                            Overlay.fromLayout layout
            }

        NoteEdit pos ->
            case editor.overlay of
                Just overlay ->
                    { editor
                        | overlay =
                            Just <|
                                Overlay.start editor.settings.subdivision pos overlay
                    }

                Nothing ->
                    editor

        DragEdit pos ->
            case editor.overlay of
                Just overlay ->
                    { editor
                        | overlay =
                            Just <|
                                Overlay.drag editor.settings.subdivision pos overlay
                    }

                Nothing ->
                    editor

        CommitEdit ->
            commit { editor | overlay = Maybe.map Overlay.finish editor.overlay }

        CancelEdit ->
            { editor | overlay = Maybe.map Overlay.deselect editor.overlay }

        ChangeSubdivision dur ->
            let
                ed =
                    { editor | settings = setSubdivision dur editor.settings }

                overlay =
                    Maybe.map
                        (Overlay.subdivide dur)
                        ed.overlay
            in
            { ed | overlay = overlay }

        SubdivisionMsg dialAction ->
            let
                ( act, maybeMsg ) =
                    Controls.updateSubdivisionDial
                        tracking.subdivisionDial
                        editor.settings.subdivision
                        dialAction

                updated =
                    { editor | tracking = activateSubdivisionDial act }
            in
            case maybeMsg of
                Just theMsg ->
                    update theMsg updated

                Nothing ->
                    updated

        ChangeAlteration semitones ->
            let
                ed =
                    { editor | settings = setAlteration semitones editor.settings }
            in
            case editor.overlay of
                Just overlay ->
                    let
                        modifier selection =
                            let
                                note =
                                    selection.note
                            in
                            case note.do of
                                Play pitch ->
                                    { selection
                                        | note =
                                            { note
                                                | do = Play { pitch | alter = semitones }
                                            }
                                    }

                                Rest ->
                                    selection
                    in
                    { ed
                        | overlay =
                            Just
                                { overlay
                                    | selection = Maybe.map modifier overlay.selection
                                }
                    }

                Nothing ->
                    ed

        AlterationMsg dialAction ->
            let
                ( act, maybeMsg ) =
                    Controls.updateAlterationDial
                        tracking.alterationDial
                        editor.settings.alteration
                        dialAction

                updated =
                    { editor | tracking = activateAlterationDial act }
            in
            case maybeMsg of
                Just theMsg ->
                    update theMsg updated

                Nothing ->
                    updated
