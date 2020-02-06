module TouchTunes.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import Music.Score.Model as Score
import TouchTunes.Action exposing (Msg(..))
import TouchTunes.Controls as Controls
import TouchTunes.Dial as Dial
import TouchTunes.Model exposing (Editor)


update : Msg -> Editor -> Editor
update msg editor =
    let
        tracking =
            editor.tracking

        activateDurationDial activation =
            { tracking | durationDial = activation }

        activateAlterationDial activation =
            { tracking | alterationDial = activation }
    in
    case log "msg" msg of
        StartEdit partNum measureNum loc ->
            let
                measure =
                    Score.measure partNum measureNum editor.score

                beat =
                    loc.beat

                pitch =
                    fromStepNumber loc.step

                note =
                    Note (Play pitch) editor.durationSetting []
            in
            update (ReplaceNote note beat)
                { editor
                    | partNum = partNum
                    , measureNum = measureNum
                    , measure = measure
                    , savedMeasure = measure
                    , selection = Just beat
                }

        DragEdit partNum measureNum loc ->
            if partNum == editor.partNum && measureNum == editor.measureNum then
                let
                    beat =
                        case editor.selection of
                            Just b ->
                                b

                            Nothing ->
                                loc.beat

                    pitch =
                        fromStepNumber loc.step
                in
                update (RepitchNote pitch beat) editor

            else
                update FinishEdit editor

        FinishEdit ->
            { editor
                | score =
                    case editor.measure of
                        Just theMeasure ->
                            Score.setMeasure
                                editor.partNum
                                editor.measureNum
                                theMeasure
                                editor.score

                        Nothing ->
                            editor.score
                , measure = Nothing
                , savedMeasure = editor.measure
                , selection = Nothing
            }

        ReplaceNote note at ->
            let
                modifier _ =
                    note
            in
            case editor.measure of
                Just theMeasure ->
                    { editor
                        | measure =
                            Just <|
                                modifyNote modifier (log "at" at) theMeasure
                    }

                Nothing ->
                    editor

        StretchNote dur at ->
            let
                modifier note =
                    { note | duration = dur }
            in
            case editor.savedMeasure of
                Just theMeasure ->
                    { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                    }

                Nothing ->
                    editor

        RepitchNote pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
            in
            case editor.savedMeasure of
                Just theMeasure ->
                    { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                    }

                Nothing ->
                    editor

        AlterNote semitones at ->
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
            case editor.measure of
                Just theMeasure ->
                    { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                    }

                Nothing ->
                    editor

        ChangeDuration dur ->
            let
                ed =
                    { editor | durationSetting = dur }
            in
            case ed.selection of
                Just theBeat ->
                    update (StretchNote dur theBeat) ed

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
                    update (AlterNote alt theBeat) ed

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
