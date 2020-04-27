module TouchTunes.Models.App exposing (App, init, update)

import Music.Models.Part as Part
import Music.Models.Score as Score exposing (Score)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Actions.Update as EditorUpdate
import TouchTunes.Models.Editor as Editor exposing (Editor)


type alias App =
    { score : Score
    , editing : Maybe { partId : Part.Id, measureNum : Int, editor : Editor }
    }


init : Score -> App
init score =
    App score Nothing


open : Part.Id -> Int -> App -> App
open pid mnum app =
    let
        maybeMeasureAttrs =
            Score.measureWithContext mnum app.score

        editMeasure ( measure, attrs ) =
            { partId = pid
            , measureNum = mnum
            , editor = Editor.open attrs measure
            }
    in
    { app | editing = Maybe.map editMeasure maybeMeasureAttrs }


close : App -> App
close app =
    { app | editing = Nothing }


update : Actions.Msg -> App -> App
update msg app =
    case app.editing of
        Just e ->
            -- route the message to the editor
            let
                updatedApp =
                    { app
                        | editing = Just { e | editor = EditorUpdate.update msg e.editor }
                    }

                save a =
                    { a
                        | score = Score.setMeasure e.measureNum e.editor.measure app.score
                    }
            in
            case msg of
                CancelEdit ->
                    close updatedApp

                SaveEdit ->
                    save updatedApp

                NextEdit ->
                    open e.partId (e.measureNum + 1) <|
                        save updatedApp

                PreviousEdit ->
                    open e.partId (e.measureNum - 1) <|
                        save updatedApp

                DoneEdit ->
                    close <|
                        save updatedApp

                _ ->
                    updatedApp

        Nothing ->
            -- these are the only messages we can accept without an editor
            case msg of
                StartEdit id mnum _ _ ->
                    open id mnum app

                _ ->
                    app
