module TouchTunes.Views.CatalogView exposing (view)

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
import Html.Events exposing (onClick)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Catalog as Catalog exposing (Catalog)
import TouchTunes.Views.AppStyles exposing (css)


view : Catalog -> Html Msg
view cat =
    div
        [ classList
            [ ( css .catalog, True )
            , ( css .active, not <| Array.isEmpty cat )
            ]
        ]
        [ ul [class (css .index)] <|
            List.map
                (\e ->
                    li []
                        [ a [ onClick <| GetScore e.id ] [ text e.title ] ]
                )
            <|
                Array.toList cat
        ]
