module TouchTunes.Update exposing (update)

import Array as Array
import Debug exposing (log)
import List.Extra exposing (findIndex)
import Maybe exposing (withDefault)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import Music.Score.Model as Score
import TouchTunes.Action
    exposing
        ( Action(..)
        , DialAction(..)
        )
import TouchTunes.Model exposing (Editor)


update : Action -> Editor -> ( Editor, Maybe Action )
update action editor =
    let
        loggedAction =
            log "action" action
    in
    case loggedAction of
        StartEdit partNum measureNum loc ->
            let
                beat =
                    loc.beat

                pitch =
                    fromStepNumber loc.step

                note =
                    Note (Play pitch) editor.durationSetting []

                measure =
                    Score.measure partNum measureNum editor.score
            in
            ( { editor
                | partNum = partNum
                , measureNum = measureNum
                , measure = measure
                , savedMeasure = Nothing
                , selection = Just beat
              }
            , Just <| ReplaceNote note beat
            )

        FinishEdit ->
            ( { editor
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
            , Nothing
            )

        ReplaceNote note at ->
            let
                modifier _ =
                    note
            in
            case editor.measure of
                Just theMeasure ->
                    ( { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                      }
                    , Nothing
                    )

                Nothing ->
                    ( editor, Nothing )

        StretchNote dur at ->
            let
                modifier note =
                    { note | duration = dur }
            in
            case editor.measure of
                Just theMeasure ->
                    ( { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                      }
                    , Nothing
                    )

                Nothing ->
                    ( editor, Nothing )

        RepitchNote pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
            in
            case editor.measure of
                Just theMeasure ->
                    ( { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                      }
                    , Nothing
                    )

                Nothing ->
                    ( editor, Nothing )

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
                    ( { editor
                        | measure =
                            Just <|
                                modifyNote modifier at theMeasure
                      }
                    , Nothing
                    )

                Nothing ->
                    ( editor, Nothing )

        DurationControl dialAction ->
            let
                currentValue =
                    editor.durationSetting

                cntrl =
                    editor.controls

                dd =
                    cntrl.durationDial

                config =
                    Tuple.first dd

                inter =
                    Tuple.second dd

                controlDD maybeAct =
                    let
                        controls =
                            editor.controls
                    in
                    { editor
                        | controls =
                            { controls
                                | durationDial =
                                    ( config, maybeAct )
                            }
                    }

                i0 =
                    case inter of
                        Just theInteraction ->
                            theInteraction.originalIndex

                        Nothing ->
                            withDefault 0 <|
                                log "findIndex" <|
                                    findIndex
                                        ((==) currentValue)
                                    <|
                                        Array.toList config.options
            in
            case dialAction of
                ChangeValue d ->
                    ( { editor
                        | durationSetting = d
                      }
                    , Nothing
                    )

                Start coord ->
                    let
                        y =
                            Tuple.second coord
                    in
                    ( controlDD <|
                        Just
                            { position = 0
                            , originalIndex = i0
                            , positionOffset = y
                            }
                    , Nothing
                    )

                Drag coord ->
                    let
                        y =
                            Tuple.second coord

                        offset =
                            case inter of
                                Just theInteraction ->
                                    theInteraction.positionOffset

                                Nothing ->
                                    y

                        rotation =
                            -2 * (y - offset)

                        sect =
                            360 // config.segments

                        shift =
                            log "shift" <|
                                floor <|
                                    toFloat rotation
                                        / toFloat sect
                                        + 0.5

                        selected =
                            Array.get (i0 + shift) config.options

                        change =
                            case selected of
                                Just theValue ->
                                    if theValue == currentValue then
                                        Nothing

                                    else
                                        selected

                                Nothing ->
                                    Nothing
                    in
                    ( controlDD <|
                        case inter of
                            Just theInteraction ->
                                Just
                                    { theInteraction
                                        | position = y - offset
                                    }

                            Nothing ->
                                Just
                                    { position = 0
                                    , originalIndex = i0
                                    , positionOffset = offset
                                    }
                    , Maybe.map (DurationControl << ChangeValue) change
                    )

                Finish ->
                    ( controlDD Nothing
                    , Nothing
                    )

                Cancel ->
                    ( controlDD Nothing
                    , Maybe.map (DurationControl << ChangeValue) <|
                        Array.get i0 config.options
                    )
