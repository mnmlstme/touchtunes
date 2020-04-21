module TouchTunes.Views.AppView exposing (view)

import Html as Html
    exposing
        ( Html
        , div
        , text
        )
import Html.Attributes exposing (class)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.App exposing (App)
import TouchTunes.Models.Sheet as Sheet exposing (Sheet)
import TouchTunes.Views.AppStyles exposing (css)
import TouchTunes.Views.EditorView as EditorView
import TouchTunes.Views.SheetView as SheetView


view : App -> Html Msg
view app =
    div [ class (css .body) ]
        [ SheetView.view <| Sheet app.score
        , case app.editor of
            Just e ->
                EditorView.view e

            Nothing ->
                text ""
        ]
