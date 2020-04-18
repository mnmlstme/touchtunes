module TouchTunes.Views.AppView exposing (view)

import Html.Styled as Html
    exposing
        ( Html
        , div
        , fromUnstyled
        , text
        )
import Html.Styled.Attributes exposing (css)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.App exposing (App)
import TouchTunes.Models.Sheet as Sheet exposing (Sheet)
import TouchTunes.Views.AppStyles as Styles
import TouchTunes.Views.EditorView as EditorView
import TouchTunes.Views.SheetView as SheetView


view : App -> Html Msg
view app =
    div [ css [ Styles.body ] ]
        [ SheetView.view <| Sheet app.score
        , case app.editor of
            Just e ->
                EditorView.view e

            Nothing ->
                text ""
        ]
