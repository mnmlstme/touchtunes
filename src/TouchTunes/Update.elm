module TouchTunes.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Beat as Beat exposing (Beat, durationFrom)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Layout as Layout
    exposing
        ( locationAfter
        , positionToLocation
        )
import Music.Measure.Model exposing (Measure, modifyNote, time)
import Music.Measure.View as MeasureView exposing (layoutFor)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, Semitones, fromStepNumber, stepNumber)
import Music.Score.Model as Score
import Music.Staff.Model as Staff
import Music.Time as Time
import TouchTunes.Action exposing (Msg(..))
import TouchTunes.Controls as Controls
import TouchTunes.Dial as Dial
import TouchTunes.Model as Editor exposing (Editor)
import TouchTunes.Overlay as Overlay


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

        activateOverlay activation =
            { tracking | overlay = activation }
    in
    case log "msg" msg of
        StartEdit partNum measureNum pos ->
            let
                measure =
                    Score.measure partNum measureNum editor.score

                layout =
                    case measure of
                        Just m ->
                            layoutFor m

                        Nothing ->
                            Layout.standard Staff.treble Time.common

                duration =
                    editor.subdivisionSetting

                loc =
                    positionToLocation
                        -- TODO: depends on time signature
                        (Layout.subdivide (duration.divisor // 4) layout)
                        pos

                at =
                    loc.beat

                pitch =
                    fromStepNumber loc.step

                note =
                    Note (Play pitch) duration []
            in
            { editor
                | partNum = partNum
                , measureNum = measureNum
                , cursor = Just at
                , selection = Just note
                , tracking =
                    activateOverlay <|
                        Just <|
                            Overlay.Track at loc
            }

        DragEdit pos ->
            case Editor.measure editor of
                Just measure ->
                    case tracking.overlay of
                        Just overlay ->
                            let
                                layout =
                                    layoutFor measure

                                loc =
                                    positionToLocation
                                        -- TODO: depends on time signature
                                        (Layout.subdivide (editor.subdivisionSetting.divisor // 4) layout)
                                        pos

                                nextLoc =
                                    locationAfter layout loc

                                beat =
                                    overlay.beat

                                modifier note =
                                    let
                                        dur =
                                            durationFrom layout.time beat nextLoc.beat
                                    in
                                    if Beat.equal beat loc.beat then
                                        { note
                                            | do = Play <| fromStepNumber loc.step
                                            , duration = dur
                                        }

                                    else
                                        { note | duration = dur }
                            in
                            { editor
                                | selection = Maybe.map modifier editor.selection
                            }

                        Nothing ->
                            editor

                Nothing ->
                    editor

        FinishEdit ->
            commit
                { editor
                    | tracking = activateOverlay Nothing
                }

        CancelEdit ->
            { editor
                | tracking = activateOverlay Nothing
            }

        ChangeSubdivision dur ->
            { editor | subdivisionSetting = dur }

        SubdivisionMsg dialAction ->
            let
                ( act, maybeMsg ) =
                    Controls.updateSubdivisionDial
                        tracking.subdivisionDial
                        editor.subdivisionSetting
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
                    { editor | alterationSetting = semitones }

                modifier note =
                    case note.do of
                        Play pitch ->
                            { note
                                | do = Play { pitch | alter = semitones }
                            }

                        Rest ->
                            note
            in
            commit
                { ed
                    | selection = Maybe.map modifier ed.selection
                }

        AlterationMsg dialAction ->
            let
                ( act, maybeMsg ) =
                    Controls.updateAlterationDial
                        tracking.alterationDial
                        editor.alterationSetting
                        dialAction

                updated =
                    { editor | tracking = activateAlterationDial act }
            in
            case maybeMsg of
                Just theMsg ->
                    update theMsg updated

                Nothing ->
                    updated
