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
import TouchTunes.Model exposing (Editor)
import TouchTunes.Overlay as Overlay


replaceNote : Note -> Beat -> Measure -> Measure
replaceNote note at =
    let
        modifier _ =
            note
    in
    modifyNote modifier at


stretchNote : Duration -> Beat -> Measure -> Measure
stretchNote dur at =
    let
        modifier note =
            { note | duration = dur }
    in
    modifyNote modifier at


repitchNote : Pitch -> Beat -> Measure -> Measure
repitchNote pitch at =
    let
        modifier note =
            { note | do = Play pitch }
    in
    modifyNote modifier at


alterNote : Semitones -> Beat -> Measure -> Measure
alterNote semitones at =
    let
        modifier note =
            case note.do of
                Play pitch ->
                    { note
                        | do = Play { pitch | alter = semitones }
                    }

                Rest ->
                    note
    in
    modifyNote modifier at


commit : Editor -> Editor
commit editor =
    let
        ed =
            { editor
                | savedMeasure = editor.measure
            }
    in
    { editor
        | score =
            case editor.measure of
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

        activateDurationDial activation =
            { tracking | durationDial = activation }

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

                loc =
                    positionToLocation layout pos

                at =
                    loc.beat

                duration =
                    editor.durationSetting

                pitch =
                    fromStepNumber loc.step

                note =
                    Note (Play pitch) duration []

                theMeasure =
                    Maybe.map (replaceNote note at) measure
            in
            { editor
                | partNum = partNum
                , measureNum = measureNum
                , measure = theMeasure
                , savedMeasure = theMeasure
                , selection = Just at
                , tracking =
                    activateOverlay <|
                        Just <|
                            Overlay.Track at loc
            }

        DragEdit partNum measureNum pos ->
            if
                partNum
                    == editor.partNum
                    && measureNum
                    == editor.measureNum
            then
                case tracking.overlay of
                    Just overlay ->
                        let
                            layout =
                                case editor.measure of
                                    Just m ->
                                        layoutFor m

                                    Nothing ->
                                        Layout.standard Staff.treble Time.common

                            loc =
                                positionToLocation layout pos

                            beat =
                                overlay.beat

                            pitch =
                                fromStepNumber loc.step
                        in
                        if Beat.equal beat loc.beat then
                            let
                                theMeasure =
                                    Maybe.map (repitchNote pitch beat) editor.savedMeasure
                            in
                            { editor
                                | measure = theMeasure
                                , savedMeasure = theMeasure
                            }

                        else
                            let
                                nextLoc =
                                    locationAfter layout loc

                                dur =
                                    durationFrom layout.time beat nextLoc.beat
                            in
                            { editor
                                | measure = Maybe.map (stretchNote dur beat) editor.savedMeasure
                            }

                    Nothing ->
                        editor

            else
                editor

        FinishEdit ->
            commit
                { editor
                    | tracking = activateOverlay Nothing
                }

        ChangeDuration dur ->
            let
                ed =
                    { editor | durationSetting = dur }
            in
            case ed.selection of
                Just theBeat ->
                    commit
                        { ed
                            | measure = Maybe.map (stretchNote dur theBeat) ed.savedMeasure
                        }

                Nothing ->
                    ed

        DurationMsg dialAction ->
            let
                ( act, maybeMsg ) =
                    Controls.updateDurationDial
                        tracking.durationDial
                        editor.durationSetting
                        dialAction

                updated =
                    { editor | tracking = activateDurationDial act }
            in
            case maybeMsg of
                Just theMsg ->
                    update theMsg updated

                Nothing ->
                    updated

        ChangeAlteration alt ->
            let
                ed =
                    { editor | alterationSetting = alt }
            in
            case ed.selection of
                Just theBeat ->
                    commit
                        { ed
                            | measure = Maybe.map (alterNote alt theBeat) ed.savedMeasure
                        }

                Nothing ->
                    ed

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
