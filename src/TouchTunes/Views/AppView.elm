module TouchTunes.Views.AppView exposing (view)

import Array exposing (Array)
import Html as Html
    exposing
        ( Html
        , a
        , div
        , li
        , text
        , ul
        )
import Html.Attributes exposing (class, classList)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.App exposing (App, Screen(..))
import TouchTunes.Models.Sheet as Sheet exposing (Sheet)
import TouchTunes.Views.AppStyles exposing (css)
import TouchTunes.Views.CatalogView as CatalogView
import TouchTunes.Views.EditorView as EditorView
import TouchTunes.Views.SheetView as SheetView


view : App -> Html Msg
view app =
    div [ class (css .body) ] <|
        List.append
            [ SheetView.view <| Sheet app.score ]
            (case app.screen of
                Editing e ->
                    [ EditorView.viewScreen
                    , EditorView.view e.editor
                    ]

                Browsing cat ->
                    [ CatalogView.view cat ]

                Attributing ->
                    [ SheetView.formHeader app.score ]

                Viewing ->
                    []
            )
