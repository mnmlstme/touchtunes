module TouchTunes.Update exposing (update)

import Debug exposing (log)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import Music.Score.Model as Score
import TouchTunes.Action exposing (Action(..))
import TouchTunes.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.Model exposing (Editor)


update : Action -> Editor -> Editor
update action editor =
    case log "action" action of
        Start partNum measureNum loc ->
            let
                beat =
                    loc.beat

                pitch =
                    fromStepNumber loc.step

                measure =
                    Score.measure partNum measureNum editor.score
            in
            { editor
                | partNum = partNum
                , measureNum = measureNum
                , measure = measure
                , savedMeasure = Nothing
                , selection = Just beat
                , hud =
                    case measure of
                        Just theMeasure ->
                            Just <| HeadUpDisplay theMeasure beat pitch

                        Nothing ->
                            Nothing
            }

        Finish ->
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
                , savedMeasure = editor.measure
                , hud = Nothing
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
