module TouchTunes.Update exposing (update)

import Debug exposing (log)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import Music.Score.Model as Score
import TouchTunes.Action exposing (Action(..))
import TouchTunes.Model exposing (Editor)


update : Action -> Editor -> ( Editor, Maybe Action )
update action editor =
    case log "action" action of
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
