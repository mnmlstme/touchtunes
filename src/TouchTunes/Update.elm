module TouchTunes.Update exposing (update)

import Array as Array
import Debug exposing (log)
import Music.Beat as Beat
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
    in
    case log "msg" msg of
        StartEdit partNum measureNum loc ->
            let
                beat =
                    Beat.roundTo editor.durationSetting loc.beat

                pitch =
                    fromStepNumber loc.step

                note =
                    Note (Play pitch) editor.durationSetting []

                measure =
                    Score.measure partNum measureNum editor.score
            in
            update (ReplaceNote note beat)
                { editor
                    | partNum = partNum
                    , measureNum = measureNum
                    , measure = measure
                    , savedMeasure = Nothing
                    , selection = Just beat
                }

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
                                modifyNote modifier at theMeasure
                    }

                Nothing ->
                    editor

        StretchNote dur at ->
            let
                modifier note =
                    { note | duration = dur }
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

        RepitchNote pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
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
            { editor | durationSetting = dur }

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
