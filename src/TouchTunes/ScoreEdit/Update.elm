module TouchTunes.ScoreEdit.Update
    exposing
        ( update
        )

import Array exposing (Array)
import Music.Score.Model as Score exposing (Score)
import TouchTunes.ScoreEdit.Action exposing (Action(..))
import TouchTunes.ScoreEdit.Model as ScoreEdit exposing (ScoreEdit, children)
import TouchTunes.PartEdit as PartEdit exposing (PartEdit)


update : Action -> ScoreEdit -> ScoreEdit
update msg editor =
    case msg of
        OnPart n action ->
            let
                subs =
                    children editor
            in
                case Array.get n subs of
                    Nothing ->
                        editor

                    Just p ->
                        let
                            updated =
                                PartEdit.update action p

                            newScore =
                                Score.set n updated.part editor.score
                        in
                            { editor
                                | active = Just ( n, updated )
                                , score = newScore
                            }
