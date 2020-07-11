module TouchTunes.Models.App exposing (App, Screen(..), attribute, close, init, open)

import Debug exposing (log)
import Json.Encode as Json
import Music.Json.Encode as MusicJson
import Music.Models.Part as Part
import Music.Models.Score as Score exposing (Score)
import TouchTunes.Actions.EditorUpdate as EditorUpdate
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Catalog as Catalog exposing (Catalog)
import TouchTunes.Models.Editor as Editor exposing (Editor)


type alias App =
    { score : Score
    , screen : Screen
    , scoreId : Maybe String
    , message : Maybe String
    }


type Screen
    = Viewing
    | Attributing
    | Editing { partId : Part.Id, measureNum : Int, editor : Editor }
    | Browsing Catalog


init : Score -> App
init score =
    App
        score
        Viewing
        Nothing
        Nothing


close : App -> App
close app =
    { app | screen = Viewing }


attribute : App -> App
attribute app =
    { app | screen = Attributing }

open : Part.Id -> Int -> App -> App
open pid mnum app =
    let
        editMeasure ( measure, attrs ) =
            Editing
                { partId = pid
                , measureNum = mnum
                , editor =  Editor.open attrs measure
                }
    in
    { app
        | screen =
            Maybe.withDefault Viewing <|
                Maybe.map
                    editMeasure
                <|
                    Score.measureWithContext mnum app.score
    }
