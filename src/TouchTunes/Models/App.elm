module TouchTunes.Models.App exposing (App, init, update)

import Debug exposing (log)
import Music.Models.Part as Part
import Music.Models.Score as Score exposing (Score)
import Music.Json.Encode as MusicJson
import Json.Encode as Json
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Actions.Update as EditorUpdate
import TouchTunes.Models.Editor as Editor exposing (Editor)


type alias App =
    { score : Score
    , editing : Maybe { partId : Part.Id, measureNum : Int, editor : Editor }
    }

init : Score -> App
init score =
    App
        (MusicJson.log "Score JSON" MusicJson.score score)
        Nothing

open : Part.Id -> Int -> App -> App
open pid mnum app =
    let
        maybeMeasureAttrs =
            Score.measureWithContext mnum app.score

        editMeasure ( measure, attrs ) =
            { partId = pid
            , measureNum = mnum
            , editor = Editor.open attrs <|
                       MusicJson.log "Measure JSON" MusicJson.measure measure
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
            case log "App got msg" msg of
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
            case log "App got msg" msg of
                StartEdit id mnum _ _ ->
                    open id mnum app

                _ ->
                    app
