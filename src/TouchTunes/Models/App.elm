module TouchTunes.Models.App exposing (App, init, update)

import Music.Models.Score exposing (Score)
import TouchTunes.Actions.Top as Actions
import TouchTunes.Actions.Update as EditorUpdate
import TouchTunes.Models.Editor as Editor exposing (Editor)


type alias App =
    { score : Score
    , editor : Maybe Editor
    }


init : Score -> App
init score =
    App score Nothing


update : Actions.Msg -> App -> App
update msg app =
    case app.editor of
        Just e ->
            -- route the message to the editor
            -- TODO: need to close editor
            { app | editor = Just <| EditorUpdate.update msg e }

        Nothing ->
            -- the only message we can accept is StartEdit
            case msg of
                Actions.StartEdit pnum mnum layout ->
                    { app | editor = Just <| Editor.open pnum mnum layout app.score }

                _ ->
                    app
